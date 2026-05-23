<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { Delete, Download, Edit, Plus, Refresh, Search } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'

import EmptyState from '@/components/common/EmptyState.vue'
import { getCrudExportConfig } from '@/constants/crud-export-config'
import {
  DICT_RESOURCE_KEYS,
  resolveDynamicLookup,
  resolveFieldOptions,
} from '@/constants/resource-config'
import { canAccessAction } from '@/permission'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dicts'
import {
  findOptionLabel,
  formatDateTime,
  formatPercent,
  formatValue,
} from '@/utils/format'

const props = defineProps({
  config: {
    type: Object,
    required: true,
  },
})

const authStore = useAuthStore()
const dictStore = useDictStore()

const formRef = ref()
const loading = ref(false)
const saving = ref(false)
const exporting = ref(false)
const dialogVisible = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const currentId = ref(null)

const searchModel = reactive({})
const formModel = reactive({})

const isEdit = computed(() => currentId.value !== null && currentId.value !== undefined)
const canManage = computed(() => canAccessAction(authStore.roleCode, props.config.actionRoles))
const canCreate = computed(() => canManage.value)
const searchFields = computed(() => props.config.searchFields || [])
const formFields = computed(() => props.config.formFields || [])
const columns = computed(() => props.config.columns || [])
const dialogTitle = computed(() => `${isEdit.value ? '编辑' : '新增'}${props.config.title}`)
const exportConfig = computed(() => getCrudExportConfig(props.config.key))
const canExport = computed(() => {
  return Boolean(exportConfig.value) && canAccessAction(authStore.roleCode, exportConfig.value.roles)
})

const formRules = computed(() => {
  const rules = {}
  formFields.value.forEach((field) => {
    const required = field.required || (!isEdit.value && field.requiredOnCreate)
    if (!required) {
      return
    }
    rules[field.prop] = [
      {
        required: true,
        message: `${field.type === 'select' ? '请选择' : '请输入'}${field.label}`,
        trigger: field.type === 'select' ? 'change' : 'blur',
      },
    ]
  })
  return rules
})

function getFieldDefault(field, mode = 'form') {
  if (typeof field.defaultValue !== 'undefined') {
    return typeof field.defaultValue === 'function' ? field.defaultValue() : field.defaultValue
  }
  if (field.type === 'number') {
    return mode === 'search' ? null : null
  }
  return ''
}

function resetModel(target, fields, mode = 'form') {
  Object.keys(target).forEach((key) => {
    delete target[key]
  })
  fields.forEach((field) => {
    target[field.prop] = getFieldDefault(field, mode)
  })
}

function applySearchScopeDefaults() {
  if (authStore.isDeptAdmin && Object.prototype.hasOwnProperty.call(searchModel, 'deptId')) {
    searchModel.deptId = Number(authStore.scopeId)
  }
  if (authStore.isMajorAdmin && Object.prototype.hasOwnProperty.call(searchModel, 'majorId')) {
    searchModel.majorId = Number(authStore.scopeId)
  }
}

function applyFormScopeDefaults() {
  if (authStore.isDeptAdmin && Object.prototype.hasOwnProperty.call(formModel, 'deptId')) {
    formModel.deptId = Number(authStore.scopeId)
  }
  if (authStore.isMajorAdmin && Object.prototype.hasOwnProperty.call(formModel, 'majorId')) {
    formModel.majorId = Number(authStore.scopeId)
  }
  if (Object.prototype.hasOwnProperty.call(formModel, 'schoolId') && !formModel.schoolId && dictStore.schools.length === 1) {
    formModel.schoolId = dictStore.schools[0].schoolId
  }
}

function resetSearch() {
  pageNum.value = 1
  resetModel(searchModel, searchFields.value, 'search')
  applySearchScopeDefaults()
}

function resetForm() {
  currentId.value = null
  resetModel(formModel, formFields.value, 'form')
  applyFormScopeDefaults()
}

function sanitizeParams(source) {
  const params = {}
  Object.entries(source).forEach(([key, value]) => {
    if (value === '' || value === null || value === undefined) {
      return
    }
    params[key] = value
  })
  return params
}

function normalizePayload() {
  const payload = {}
  formFields.value.forEach((field) => {
    const value = formModel[field.prop]
    payload[field.prop] = value === undefined ? null : value
  })
  return payload
}

function fieldOptions(field, model) {
  return resolveFieldOptions(field, dictStore, model)
}

function fieldDisabled(field) {
  if (field.disabled) {
    return true
  }
  if (authStore.isDeptAdmin && field.prop === 'deptId') {
    return true
  }
  if (authStore.isMajorAdmin && field.prop === 'majorId') {
    return true
  }
  return false
}

function formatCell(row, column) {
  const value = row[column.prop]
  if (column.dynamicLookup) {
    return resolveDynamicLookup(value, row, dictStore)
  }
  if (column.lookupKey) {
    return findOptionLabel(fieldOptions({ optionsKey: column.lookupKey }, row), value)
  }
  if (column.options) {
    return findOptionLabel(column.options, value)
  }
  if (column.format === 'datetime') {
    return formatDateTime(value)
  }
  if (column.format === 'percent') {
    return formatPercent(value)
  }
  return formatValue(value)
}

async function loadData() {
  loading.value = true
  try {
    const params = {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      ...sanitizeParams(searchModel),
    }
    const response = await props.config.service.list(params)
    tableData.value = response?.records || []
    total.value = response?.total || 0
  } finally {
    loading.value = false
  }
}

async function handleSearch() {
  pageNum.value = 1
  await loadData()
}

async function handleEdit(row) {
  const detail = await props.config.service.detail(row[props.config.idField])
  resetForm()
  currentId.value = row[props.config.idField]
  formFields.value.forEach((field) => {
    formModel[field.prop] = detail?.[field.prop] ?? getFieldDefault(field)
  })
  dialogVisible.value = true
}

function handleCreate() {
  resetForm()
  dialogVisible.value = true
}

async function handleDelete(row) {
  await ElMessageBox.confirm(`确定删除“${props.config.title}”中的这条记录吗？`, '删除确认', {
    type: 'warning',
    confirmButtonText: '删除',
    cancelButtonText: '取消',
  })
  await props.config.service.remove(row[props.config.idField])
  ElMessage.success('删除成功')
  if (DICT_RESOURCE_KEYS.includes(props.config.key)) {
    await dictStore.loadAll(true)
  }
  await loadData()
}

async function handleSubmit() {
  if (!formRef.value) {
    return
  }
  await formRef.value.validate()
  saving.value = true
  try {
    let payload = normalizePayload()
    if (props.config.beforeSubmit) {
      payload = await props.config.beforeSubmit(payload, { isEdit: isEdit.value })
    }
    if (isEdit.value) {
      await props.config.service.update(currentId.value, payload)
    } else {
      await props.config.service.create(payload)
    }
    ElMessage.success(`${isEdit.value ? '更新' : '创建'}成功`)
    dialogVisible.value = false
    if (DICT_RESOURCE_KEYS.includes(props.config.key)) {
      await dictStore.loadAll(true)
    }
    await loadData()
  } finally {
    saving.value = false
  }
}

function handlePageSizeChange() {
  pageNum.value = 1
  loadData()
}

async function handleExport() {
  if (!exportConfig.value) {
    return
  }
  exporting.value = true
  try {
    await exportConfig.value.run(sanitizeParams(searchModel), { authStore, dictStore })
    ElMessage.success('导出任务已完成')
  } finally {
    exporting.value = false
  }
}

watch(
  () => formModel.scopeType,
  (value, previous) => {
    if (value !== previous && Object.prototype.hasOwnProperty.call(formModel, 'scopeId')) {
      formModel.scopeId = ''
    }
  },
)

watch(
  () => formModel.deptId,
  (value, previous) => {
    if (value !== previous && Object.prototype.hasOwnProperty.call(formModel, 'majorId') && !authStore.isMajorAdmin) {
      formModel.majorId = ''
    }
  },
)

watch(
  () => searchModel.deptId,
  (value, previous) => {
    if (value !== previous && Object.prototype.hasOwnProperty.call(searchModel, 'majorId') && !authStore.isMajorAdmin) {
      searchModel.majorId = ''
    }
  },
)

watch(
  () => props.config.key,
  async () => {
    resetSearch()
    resetForm()
    await loadData()
  },
)

onMounted(async () => {
  resetSearch()
  resetForm()
  await loadData()
})
</script>

<template>
  <div class="page-shell">
    <section class="page-card crud-page">
      <div class="section-title crud-page__header">
        <div>
          <h2>{{ config.title }}</h2>
        </div>
        <el-tag type="info" effect="plain">{{ total }} 条记录</el-tag>
      </div>

      <el-form label-position="top">
        <div class="form-grid form-grid--compact crud-page__search-grid">
          <el-form-item v-for="field in searchFields" :key="field.prop" :label="field.label">
            <el-input
              v-if="field.type === 'input'"
              v-model="searchModel[field.prop]"
              :placeholder="field.placeholder || `请输入${field.label}`"
              clearable
            />
            <el-select
              v-else-if="field.type === 'select'"
              v-model="searchModel[field.prop]"
              :placeholder="field.placeholder || `请选择${field.label}`"
              clearable
              class="full-width"
            >
              <el-option
                v-for="option in fieldOptions(field, searchModel)"
                :key="option.value"
                :label="option.label"
                :value="option.value"
              />
            </el-select>
            <el-input-number
              v-else-if="field.type === 'number'"
              v-model="searchModel[field.prop]"
              :precision="field.precision ?? 0"
              :min="field.min"
              :max="field.max"
              class="full-width"
              controls-position="right"
            />
          </el-form-item>
        </div>
      </el-form>

      <div class="crud-page__toolbar">
        <div class="toolbar">
          <el-button type="primary" :icon="Search" @click="handleSearch">查询</el-button>
          <el-button :icon="Refresh" @click="resetSearch(); loadData()">重置</el-button>
        </div>
        <div class="toolbar">
          <el-button v-if="canCreate" type="primary" plain :icon="Plus" @click="handleCreate">新增记录</el-button>
          <el-button v-if="canExport" plain :loading="exporting" :icon="Download" @click="handleExport">{{ exportConfig?.label }}</el-button>
        </div>
      </div>

      <div class="crud-page__divider"></div>

      <el-table v-loading="loading" :data="tableData" stripe class="data-table">
        <template v-if="columns.length">
          <el-table-column
            v-for="column in columns"
            :key="column.prop"
            :prop="column.prop"
            :label="column.label"
            :width="column.width"
            :min-width="column.minWidth"
            show-overflow-tooltip
          >
            <template #default="scope">
              {{ formatCell(scope.row, column) }}
            </template>
          </el-table-column>
        </template>

        <el-table-column v-if="canManage" label="操作" width="170" fixed="right">
          <template #default="scope">
            <el-button link type="primary" :icon="Edit" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button link type="danger" :icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>

        <template #empty>
          <EmptyState class="empty-inline" title="暂无列表数据" description="可以调整筛选条件，或者直接新增一条记录。" />
        </template>
      </el-table>

      <div class="crud-page__pagination">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          background
          layout="total, sizes, prev, pager, next, jumper"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          @current-change="loadData"
          @size-change="handlePageSizeChange"
        />
      </div>
    </section>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="780px" destroy-on-close>
      <el-form ref="formRef" :model="formModel" :rules="formRules" label-position="top">
        <div class="form-grid">
          <el-form-item
            v-for="field in formFields"
            :key="field.prop"
            :label="field.label"
            :prop="field.prop"
            :class="field.type === 'textarea' ? 'span-2' : ''"
          >
            <el-input
              v-if="field.type === 'input'"
              v-model="formModel[field.prop]"
              :type="field.password ? 'password' : 'text'"
              :show-password="field.password"
              :disabled="fieldDisabled(field)"
              :placeholder="field.placeholder || `请输入${field.label}`"
              clearable
            />
            <el-select
              v-else-if="field.type === 'select'"
              v-model="formModel[field.prop]"
              :disabled="fieldDisabled(field)"
              :placeholder="field.placeholder || `请选择${field.label}`"
              clearable
              class="full-width"
            >
              <el-option
                v-for="option in fieldOptions(field, formModel)"
                :key="option.value"
                :label="option.label"
                :value="option.value"
              />
            </el-select>
            <el-input-number
              v-else-if="field.type === 'number'"
              v-model="formModel[field.prop]"
              :precision="field.precision ?? 0"
              :min="field.min"
              :max="field.max"
              :disabled="fieldDisabled(field)"
              class="full-width"
              controls-position="right"
            />
            <el-input
              v-else-if="field.type === 'textarea'"
              v-model="formModel[field.prop]"
              type="textarea"
              :rows="field.rows || 3"
              :placeholder="field.placeholder || `请输入${field.label}`"
            />
            <div v-if="field.helperText" class="crud-page__helper">{{ field.helperText }}</div>
          </el-form-item>
        </div>
      </el-form>

      <template #footer>
        <div class="toolbar">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" :loading="saving" @click="handleSubmit">保存</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.crud-page {
  padding: 22px;
}

.crud-page__header {
  margin-bottom: 8px;
}

.crud-page__search-grid {
  margin-top: 10px;
}

.crud-page__toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-top: 4px;
}

.crud-page__divider {
  height: 1px;
  margin: 18px 0 16px;
  background: linear-gradient(90deg, rgba(22, 52, 61, 0.1), rgba(22, 52, 61, 0.02));
}

.crud-page__pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.crud-page__helper {
  margin-top: 6px;
  color: var(--text-muted);
  font-size: 12px;
}

@media (max-width: 900px) {
  .crud-page__toolbar {
    flex-direction: column;
    align-items: stretch;
  }

  .crud-page__toolbar .toolbar {
    justify-content: flex-start;
  }
}
</style>

