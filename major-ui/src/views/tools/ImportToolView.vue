<script setup>
import { reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { UploadFilled } from '@element-plus/icons-vue'

import EmptyState from '@/components/common/EmptyState.vue'
import { importData } from '@/api/importExport'
import { RESOURCE_IMPORT_OPTIONS } from '@/constants/static-options'

const uploading = ref(false)
const selectedType = ref(RESOURCE_IMPORT_OPTIONS[0].value)
const fileList = ref([])
const selectedFile = ref(null)
const importResult = ref(null)

const notes = reactive([
  '主数据导入重复时会直接报错，适合演示唯一性校验。',
  '年度数据导入按业务唯一键覆盖更新，适合反复演示。',
  '支持 Excel 与 CSV 文件。',
])

function handleFileChange(file, files) {
  selectedFile.value = file.raw
  fileList.value = files.slice(-1)
}

function handleRemove() {
  selectedFile.value = null
  fileList.value = []
}

async function handleImport() {
  if (!selectedFile.value) {
    ElMessage.warning('请先选择导入文件')
    return
  }
  uploading.value = true
  try {
    importResult.value = await importData(selectedType.value, selectedFile.value)
    ElMessage.success('导入请求已完成')
  } finally {
    uploading.value = false
  }
}
</script>

<template>
  <div class="page-shell">
    <section class="page-card import-view__panel">
      <div class="section-title">
        <div>
          <h2>数据导入工具</h2>
          <p>覆盖教师、学生、课程、招生、经费与毕业去向六类常用数据导入场景。</p>
        </div>
        <el-tag type="success" effect="plain">模板导入</el-tag>
      </div>

      <div class="grid-two">
        <div class="page-card import-view__inner">
          <el-form label-position="top">
            <el-form-item label="导入类型">
              <el-select v-model="selectedType" class="full-width">
                <el-option v-for="item in RESOURCE_IMPORT_OPTIONS" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-form>

          <el-upload
            drag
            :auto-upload="false"
            :limit="1"
            :file-list="fileList"
            accept=".xlsx,.xls,.csv"
            @change="handleFileChange"
            @remove="handleRemove"
          >
            <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
            <div class="el-upload__text">将文件拖到这里，或 <em>点击上传</em></div>
            <template #tip>
              <div class="el-upload__tip">建议使用导出模板整理列名，减少字段格式错误。</div>
            </template>
          </el-upload>

          <div class="toolbar" style="margin-top: 18px;">
            <el-button type="primary" :loading="uploading" @click="handleImport">开始导入</el-button>
            <el-button @click="handleRemove">清空文件</el-button>
          </div>
        </div>

        <div class="page-card import-view__inner">
          <div class="section-title">
            <div>
              <h3>导入规则说明</h3>
              <p>答辩时可以用这里说明系统对异常数据和重复数据的处理策略。</p>
            </div>
          </div>

          <el-timeline>
            <el-timeline-item v-for="(note, index) in notes" :key="index" type="success" :timestamp="`规则 ${index + 1}`">
              {{ note }}
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>
    </section>

    <section class="page-card import-view__result">
      <div class="section-title">
        <div>
          <h3>导入结果</h3>
          <p>实时展示任务状态、总行数、成功数与失败数。</p>
        </div>
      </div>

      <el-descriptions v-if="importResult" :column="3" border>
        <el-descriptions-item label="任务ID">{{ importResult.taskId }}</el-descriptions-item>
        <el-descriptions-item label="任务状态">{{ importResult.status }}</el-descriptions-item>
        <el-descriptions-item label="总行数">{{ importResult.totalRows }}</el-descriptions-item>
        <el-descriptions-item label="成功行数">{{ importResult.successRows }}</el-descriptions-item>
        <el-descriptions-item label="失败行数">{{ importResult.failRows }}</el-descriptions-item>
        <el-descriptions-item label="错误信息">{{ importResult.errorMessage || '--' }}</el-descriptions-item>
      </el-descriptions>
      <EmptyState v-else title="还没有导入结果" description="上传并导入文件后，这里会显示本次任务的返回结果。" />
    </section>
  </div>
</template>

<style scoped>
.import-view__panel,
.import-view__result,
.import-view__inner {
  padding: 22px;
}
</style>