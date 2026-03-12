<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { Download, Refresh } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

import EmptyState from '@/components/common/EmptyState.vue'
import { exportWarningList } from '@/api/importExport'
import { STATUS_TAGS } from '@/constants/resource-config'
import { recalculateWarnings } from '@/api/dashboard'
import { listWarnings } from '@/api/warning'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dicts'
import { formatDateTime, formatValue } from '@/utils/format'

const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const exporting = ref(false)
const filters = reactive({
  deptId: null,
  majorId: null,
  year: new Date().getFullYear(),
})
const warnings = ref([])
const recalculating = ref(false)

const majorOptions = computed(() => {
  if (filters.deptId) {
    return dictStore.majors.filter((item) => item.deptId === filters.deptId)
  }
  return dictStore.majors
})

const canExport = computed(() => !authStore.isMajorAdmin)

function buildExportParams() {
  const params = {}
  if (filters.deptId) {
    params.deptId = filters.deptId
  }
  if (filters.majorId) {
    params.majorId = filters.majorId
  }
  if (filters.year) {
    params.year = filters.year
  }
  return params
}

function applyScopeDefaults() {
  if (authStore.isDeptAdmin) {
    filters.deptId = Number(authStore.scopeId)
  }
  if (authStore.isMajorAdmin) {
    filters.majorId = Number(authStore.scopeId)
    const major = dictStore.majors.find((item) => Number(item.majorId) === Number(authStore.scopeId))
    if (major) {
      filters.deptId = major.deptId
    }
  }
}

async function loadWarnings() {
  loading.value = true
  try {
    warnings.value = await listWarnings({ ...buildExportParams() })
  } finally {
    loading.value = false
  }
}

function resetFilters() {
  filters.deptId = null
  filters.majorId = null
  filters.year = new Date().getFullYear()
  applyScopeDefaults()
}

async function handleExport() {
  exporting.value = true
  try {
    await exportWarningList(buildExportParams())
    ElMessage.success('预警清单导出成功')
  } finally {
    exporting.value = false
  }
}

async function handleRecalculate() {
  recalculating.value = true
  try {
    await recalculateWarnings()
    ElMessage.success('预警重算已完成')
    await loadWarnings()
  } finally {
    recalculating.value = false
  }
}

watch(
  () => filters.deptId,
  (value, previous) => {
    if (value !== previous && !authStore.isMajorAdmin) {
      filters.majorId = null
    }
  },
)

onMounted(async () => {
  applyScopeDefaults()
  await loadWarnings()
})
</script>

<template>
  <div class="page-shell">
    <section class="page-card warning-view">
      <div class="section-title warning-view__header">
        <div>
          <h2>预警中心</h2>
          <p>在同一张卡片中完成筛选、重算、导出和结果查看，方便答辩时连续演示预警闭环。</p>
        </div>
        <el-tag type="danger" effect="dark">{{ warnings.length }} 条预警</el-tag>
      </div>

      <el-form label-position="top">
        <div class="form-grid form-grid--compact">
          <el-form-item label="学院">
            <el-select v-model="filters.deptId" class="full-width" clearable :disabled="authStore.isDeptAdmin || authStore.isMajorAdmin">
              <el-option v-for="item in dictStore.departments" :key="item.deptId" :label="item.name" :value="item.deptId" />
            </el-select>
          </el-form-item>
          <el-form-item label="专业">
            <el-select v-model="filters.majorId" class="full-width" clearable :disabled="authStore.isMajorAdmin">
              <el-option v-for="item in majorOptions" :key="item.majorId" :label="item.name" :value="item.majorId" />
            </el-select>
          </el-form-item>
          <el-form-item label="年份">
            <el-input-number v-model="filters.year" class="full-width" :min="2020" :max="2100" controls-position="right" />
          </el-form-item>
        </div>
      </el-form>

      <div class="warning-view__toolbar">
        <div class="toolbar">
          <el-button type="primary" @click="loadWarnings">查询预警</el-button>
          <el-button :icon="Refresh" @click="resetFilters(); loadWarnings()">重置条件</el-button>
        </div>
        <div class="toolbar">
          <el-button v-if="canExport" plain :icon="Download" :loading="exporting" @click="handleExport">导出预警清单</el-button>
          <el-button v-if="authStore.isSchoolAdmin" type="danger" plain :loading="recalculating" @click="handleRecalculate">重新计算预警</el-button>
        </div>
      </div>

      <div class="warning-view__divider"></div>

      <el-table v-loading="loading" :data="warnings" stripe>
        <el-table-column label="专业" prop="majorName" min-width="180" show-overflow-tooltip />
        <el-table-column label="指标名称" prop="indicatorName" min-width="160" show-overflow-tooltip />
        <el-table-column label="指标编码" prop="indicatorCode" min-width="180" />
        <el-table-column label="年份" prop="statYear" width="90" />
        <el-table-column label="阈值" min-width="100">
          <template #default="scope">{{ formatValue(scope.row.thresholdValue) }}</template>
        </el-table-column>
        <el-table-column label="实际值" min-width="100">
          <template #default="scope">{{ formatValue(scope.row.actualValue) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="110">
          <template #default="scope">
            <el-tag :type="STATUS_TAGS[scope.row.status] || 'info'">{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="触发时间" min-width="160">
          <template #default="scope">{{ formatDateTime(scope.row.triggeredAt) }}</template>
        </el-table-column>
        <el-table-column label="说明" prop="message" min-width="240" show-overflow-tooltip />
        <template #empty>
          <EmptyState title="当前没有预警记录" description="说明指标运行整体平稳，或可以调整筛选条件查看其他范围。" />
        </template>
      </el-table>
    </section>
  </div>
</template>

<style scoped>
.warning-view {
  padding: 22px;
}

.warning-view__header {
  margin-bottom: 8px;
}

.warning-view__toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.warning-view__divider {
  height: 1px;
  margin: 18px 0 16px;
  background: linear-gradient(90deg, rgba(22, 52, 61, 0.1), rgba(22, 52, 61, 0.02));
}

@media (max-width: 900px) {
  .warning-view__toolbar {
    flex-direction: column;
    align-items: stretch;
  }

  .warning-view__toolbar .toolbar {
    justify-content: flex-start;
  }
}
</style>
