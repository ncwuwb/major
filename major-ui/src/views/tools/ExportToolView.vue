<script setup>
import { computed, reactive } from 'vue'
import { ElMessage } from 'element-plus'

import {
  exportAnnualIndicators,
  exportMajorSummary,
  exportWarningList,
} from '@/api/importExport'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dicts'

const authStore = useAuthStore()
const dictStore = useDictStore()

const currentYear = new Date().getFullYear()
const loadingKey = reactive({
  summary: false,
  warning: false,
  annual: false,
})

const filters = reactive({
  deptId: null,
  majorId: null,
  year: currentYear,
  startYear: currentYear - 4,
  endYear: currentYear,
})

const majorOptions = computed(() => {
  if (filters.deptId) {
    return dictStore.majors.filter((item) => item.deptId === filters.deptId)
  }
  return dictStore.majors
})

function applyScopeDefaults() {
  if (authStore.isDeptAdmin) {
    filters.deptId = Number(authStore.scopeId)
  }
  if (authStore.isMajorAdmin) {
    filters.majorId = Number(authStore.scopeId)
    const major = dictStore.majors.find((item) => item.majorId === Number(authStore.scopeId))
    if (major) {
      filters.deptId = major.deptId
    }
  }
}

applyScopeDefaults()

async function runExport(type, exporter) {
  loadingKey[type] = true
  try {
    await exporter()
    ElMessage.success('导出任务已触发，请查看浏览器下载文件')
  } finally {
    loadingKey[type] = false
  }
}
</script>

<template>
  <div class="page-shell">
    <section class="page-card export-view__panel">
      <div class="section-title">
        <div>
          <h2>数据导出工具</h2>
          <p>支持专业汇总、预警清单和年度指标趋势三类 Excel 导出。</p>
        </div>
        <el-tag type="warning" effect="plain">Excel 导出</el-tag>
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
          <el-form-item label="开始年份">
            <el-input-number v-model="filters.startYear" class="full-width" :min="2020" :max="2100" controls-position="right" />
          </el-form-item>
          <el-form-item label="结束年份">
            <el-input-number v-model="filters.endYear" class="full-width" :min="2020" :max="2100" controls-position="right" />
          </el-form-item>
        </div>
      </el-form>

      <div class="grid-three export-view__actions">
        <div class="page-card export-view__action-card">
          <h3>专业汇总报表</h3>
          <p>导出当前筛选范围下的专业概览、关键指标和基础画像。</p>
          <el-button type="primary" :loading="loadingKey.summary" @click="runExport('summary', () => exportMajorSummary({ deptId: filters.deptId, majorId: filters.majorId, year: filters.year }))">
            导出专业汇总
          </el-button>
        </div>

        <div class="page-card export-view__action-card">
          <h3>预警清单</h3>
          <p>导出当前年份的预警记录，适合答辩中展示系统异常发现能力。</p>
          <el-button type="primary" :loading="loadingKey.warning" @click="runExport('warning', () => exportWarningList({ deptId: filters.deptId, majorId: filters.majorId, year: filters.year }))">
            导出预警清单
          </el-button>
        </div>

        <div class="page-card export-view__action-card">
          <h3>年度指标趋势</h3>
          <p>按时间区间导出趋势报表，便于对比年度变化和培养质量演进。</p>
          <el-button type="primary" :loading="loadingKey.annual" @click="runExport('annual', () => exportAnnualIndicators({ deptId: filters.deptId, majorId: filters.majorId, startYear: filters.startYear, endYear: filters.endYear }))">
            导出趋势报表
          </el-button>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.export-view__panel,
.export-view__action-card {
  padding: 22px;
}

.export-view__actions {
  margin-top: 10px;
}

.export-view__action-card h3,
.export-view__action-card p {
  margin: 0;
}

.export-view__action-card p {
  margin: 10px 0 18px;
  color: var(--text-secondary);
  line-height: 1.7;
}
</style>