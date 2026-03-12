<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'

import ChartPanel from '@/components/common/ChartPanel.vue'
import EmptyState from '@/components/common/EmptyState.vue'
import MiniDonutChart from '@/components/common/MiniDonutChart.vue'
import {
  fetchOverview,
  fetchRank,
  fetchScores,
  fetchTrend,
  fetchWarnings,
  recalculateWarnings,
} from '@/api/dashboard'
import { exportAnnualIndicators, exportMajorSummary } from '@/api/importExport'
import { METRIC_OPTIONS, ROLE_OPTIONS } from '@/constants/static-options'
import { STATUS_TAGS } from '@/constants/resource-config'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dicts'
import { formatDateTime, formatPercent, formatValue } from '@/utils/format'

const CHART_GROUPS = [
  {
    key: 'overview',
    title: '资源概览',
    description: '查看专业规模、资源数量和关键比率概况。',
  },
  {
    key: 'score-warning',
    title: '评分预警',
    description: '聚焦综合评分排名与预警诊断结果。',
  },
  {
    key: 'trend-rank',
    title: '趋势排行',
    description: '展示年度趋势变化和专业横向排行。',
  },
  {
    key: 'compare',
    title: '对比分析',
    description: '查看同年横向差异和年度同比变化。',
  },
]

const authStore = useAuthStore()
const dictStore = useDictStore()

const currentYear = new Date().getFullYear()
const activeChartGroup = ref('overview')
const filters = reactive({
  deptId: null,
  majorId: null,
  year: currentYear,
  compareMetric: 'EMPLOYMENT_RATE',
  trendMetric: 'ADMISSION_COMPLETION_RATE',
  rankMetric: 'EMPLOYMENT_RATE',
})

const loading = reactive({
  overview: false,
  trend: false,
  rank: false,
  compare: false,
  score: false,
  warning: false,
})

const overview = ref({})
const trendList = ref([])
const rankList = ref([])
const compareList = ref([])
const yoyComparison = ref([])
const scoreList = ref([])
const warningList = ref([])
const recalculating = ref(false)
const exporting = ref(false)

const metricLabelMap = Object.fromEntries(METRIC_OPTIONS.map((item) => [item.value, item.label]))
const roleLabelMap = Object.fromEntries(ROLE_OPTIONS.map((item) => [item.value, item.label]))

const activeGroupMeta = computed(() => {
  return CHART_GROUPS.find((item) => item.key === activeChartGroup.value) || CHART_GROUPS[0]
})

const majorOptions = computed(() => {
  if (filters.deptId) {
    return dictStore.majors.filter((item) => item.deptId === filters.deptId)
  }
  return dictStore.majors
})

const currentDeptName = computed(() => {
  return dictStore.departments.find((item) => Number(item.deptId) === Number(filters.deptId))?.name || '全校范围'
})

const currentMajorName = computed(() => {
  return dictStore.majors.find((item) => Number(item.majorId) === Number(filters.majorId))?.name || '全部专业'
})

const scopeTags = computed(() => [
  `${filters.year} 年度`,
  currentDeptName.value,
  currentMajorName.value,
  roleLabelMap[authStore.roleCode] || '当前登录角色',
])

const topScoreList = computed(() => {
  return [...scoreList.value]
    .sort((a, b) => Number(b.totalScore || 0) - Number(a.totalScore || 0))
    .slice(0, 6)
})

const champion = computed(() => topScoreList.value[0] || null)
const warningPreview = computed(() => warningList.value.slice(0, 3))
const topWarningCount = computed(() => warningList.value.filter((item) => item.status === 'ACTIVE').length)
const canExportDashboard = computed(() => !authStore.isMajorAdmin)

const briefHighlights = computed(() => [
  { label: '综合评分冠军', value: champion.value?.majorName || '待生成' },
  { label: '当前活跃预警', value: `${topWarningCount.value} 条` },
  {
    label: '就业 / 升学',
    value: `${formatPercent(overview.value.employmentRate)} / ${formatPercent(overview.value.postgraduateRate)}`,
  },
])

const resourceMetrics = computed(() => [
  { label: '专业总数', value: Number(overview.value.majorCount || 0), color: '#0f9d8a' },
  { label: '教师总数', value: Number(overview.value.teacherCount || 0), color: '#2563eb' },
  { label: '学生总数', value: Number(overview.value.studentCount || 0), color: '#f29b38' },
  { label: '竞赛获奖', value: Number(overview.value.competitionAwardCount || 0), color: '#c97b14' },
  { label: '活跃预警', value: Number(topWarningCount.value || 0), color: '#d64545' },
])

const rateMetrics = computed(() => [
  {
    label: '博士占比',
    value: Number(overview.value.phdRate || 0),
    accent: '#0f9d8a',
    hint: '反映师资结构质量',
  },
  {
    label: '招生完成率',
    value: Number(overview.value.admissionCompletionRate || 0),
    accent: '#2563eb',
    hint: '反映招生执行情况',
  },
  {
    label: '经费使用率',
    value: Number(overview.value.fundingUtilizationRate || 0),
    accent: '#f29b38',
    hint: '反映资源配置效率',
  },
  {
    label: '就业率',
    value: Number(overview.value.employmentRate || 0),
    accent: '#d64545',
    hint: '反映毕业去向质量',
  },
  {
    label: '升学率',
    value: Number(overview.value.postgraduateRate || 0),
    accent: '#8b5cf6',
    hint: '反映继续深造情况',
  },
])

const warningStatusData = computed(() => {
  const map = {
    ACTIVE: { name: '活跃预警', value: 0, color: '#d64545' },
    CLEARED: { name: '已清除', value: 0, color: '#0f9d8a' },
    INACTIVE: { name: '非激活', value: 0, color: '#94a3b8' },
  }

  warningList.value.forEach((item) => {
    if (map[item.status]) {
      map[item.status].value += 1
    }
  })

  return Object.values(map).filter((item) => item.value > 0)
})

const championSummary = computed(() => {
  if (!champion.value) {
    return '当前筛选范围内暂未形成综合评分结果，建议先补充招生、经费和毕业去向等年度数据。'
  }

  return `${champion.value.majorName} 当前综合得分领先，就业率 ${formatPercent(champion.value.employmentRate)}，升学率 ${formatPercent(champion.value.postgraduateRate)}。`
})

const resourceOverviewOption = computed(() => {
  if (!resourceMetrics.value.length) {
    return { series: [] }
  }

  return {
    tooltip: chartTooltipConfig('shadow'),
    grid: { top: 30, right: 20, bottom: 32, left: 48 },
    xAxis: {
      type: 'category',
      data: resourceMetrics.value.map((item) => item.label),
      axisLabel: { color: '#4a6670', interval: 0 },
      axisLine: { lineStyle: { color: '#bdd0d6' } },
    },
    yAxis: {
      type: 'value',
      axisLabel: { color: '#4a6670' },
      splitLine: { lineStyle: { color: 'rgba(22,52,61,0.08)' } },
    },
    series: [
      {
        type: 'bar',
        barWidth: 34,
        itemStyle: {
          borderRadius: [12, 12, 0, 0],
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: resourceMetrics.value.map((item) => ({
          value: item.value,
          itemStyle: {
            color: item.color,
          },
        })),
      },
    ],
  }
})

const scoreRankingOption = computed(() => {
  if (!topScoreList.value.length) {
    return { series: [] }
  }

  return {
    tooltip: chartTooltipConfig('shadow'),
    grid: { top: 22, right: 20, bottom: 20, left: 96 },
    xAxis: {
      type: 'value',
      axisLabel: { color: '#4a6670' },
      splitLine: { lineStyle: { color: 'rgba(22,52,61,0.08)' } },
    },
    yAxis: {
      type: 'category',
      inverse: true,
      data: topScoreList.value.map((item) => item.majorName),
      axisLabel: { color: '#4a6670' },
      axisLine: { lineStyle: { color: '#bdd0d6' } },
    },
    series: [
      {
        name: '综合评分',
        type: 'bar',
        barWidth: 18,
        itemStyle: {
          borderRadius: [0, 12, 12, 0],
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 1,
            y2: 0,
            colorStops: [
              { offset: 0, color: '#0f9d8a' },
              { offset: 1, color: '#5ec9bb' },
            ],
          },
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: topScoreList.value.map((item) => Number(item.totalScore || 0)),
      },
    ],
  }
})

const warningDistributionOption = computed(() => {
  if (!warningStatusData.value.length) {
    return { series: [] }
  }

  return {
    tooltip: {
      trigger: 'item',
      backgroundColor: 'rgba(14, 34, 40, 0.92)',
      borderColor: 'rgba(255,255,255,0.08)',
      textStyle: { color: '#f2fbfb' },
      extraCssText: 'box-shadow: 0 16px 40px rgba(8,24,29,0.18); border-radius: 14px;',
    },
    legend: {
      bottom: 0,
      itemWidth: 10,
      itemHeight: 10,
      textStyle: { color: '#4a6670' },
    },
    series: [
      {
        type: 'pie',
        radius: ['52%', '74%'],
        center: ['50%', '42%'],
        label: {
          formatter: '{d}%',
          color: '#17343d',
          fontWeight: 700,
        },
        itemStyle: {
          borderColor: '#fff',
          borderWidth: 3,
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: warningStatusData.value.map((item) => ({
          name: item.name,
          value: item.value,
          itemStyle: { color: item.color },
        })),
      },
    ],
  }
})

const trendOption = computed(() => {
  if (!trendList.value.length) {
    return { series: [] }
  }

  return {
    color: ['#0f9d8a'],
    tooltip: chartTooltipConfig(),
    grid: { top: 34, right: 18, bottom: 24, left: 46 },
    xAxis: {
      type: 'category',
      data: trendList.value.map((item) => item.statYear),
      boundaryGap: false,
      axisLine: { lineStyle: { color: '#bdd0d6' } },
      axisLabel: { color: '#4a6670' },
    },
    yAxis: {
      type: 'value',
      axisLabel: { formatter: '{value}%', color: '#4a6670' },
      splitLine: { lineStyle: { color: 'rgba(22,52,61,0.08)' } },
    },
    series: [
      {
        name: metricLabelMap[filters.trendMetric],
        type: 'line',
        smooth: true,
        symbolSize: 9,
        lineStyle: { width: 3 },
        itemStyle: { color: '#0f9d8a', borderColor: '#fff', borderWidth: 2 },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(15,157,138,0.26)' },
              { offset: 1, color: 'rgba(15,157,138,0.02)' },
            ],
          },
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: trendList.value.map((item) => Number(item.metricValue || 0)),
      },
    ],
  }
})

const rankOption = computed(() => {
  if (!rankList.value.length) {
    return { series: [] }
  }

  return {
    color: ['#f29b38'],
    tooltip: chartTooltipConfig('shadow'),
    grid: { top: 30, right: 18, bottom: 40, left: 46 },
    xAxis: {
      type: 'category',
      data: rankList.value.map((item) => item.majorName),
      axisLabel: { interval: 0, rotate: 18, color: '#4a6670' },
      axisLine: { lineStyle: { color: '#bdd0d6' } },
    },
    yAxis: {
      type: 'value',
      axisLabel: { formatter: '{value}%', color: '#4a6670' },
      splitLine: { lineStyle: { color: 'rgba(22,52,61,0.08)' } },
    },
    series: [
      {
        name: metricLabelMap[filters.rankMetric],
        type: 'bar',
        barWidth: 24,
        itemStyle: {
          borderRadius: [12, 12, 0, 0],
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: '#f6b255' },
              { offset: 1, color: '#d88616' },
            ],
          },
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: rankList.value.map((item) => Number(item.metricValue || 0)),
      },
    ],
  }
})

const compareOption = computed(() => {
  if (!compareList.value.length) {
    return { series: [] }
  }

  return {
    color: ['#0f9d8a'],
    tooltip: chartTooltipConfig('shadow'),
    grid: { top: 28, right: 18, bottom: 18, left: 92 },
    xAxis: {
      type: 'value',
      axisLabel: { formatter: '{value}%', color: '#4a6670' },
      splitLine: { lineStyle: { color: 'rgba(22,52,61,0.08)' } },
    },
    yAxis: {
      type: 'category',
      data: compareList.value.map((item) => item.majorName),
      inverse: true,
      axisLabel: { color: '#4a6670' },
      axisLine: { lineStyle: { color: '#bdd0d6' } },
    },
    series: [
      {
        name: metricLabelMap[filters.compareMetric],
        type: 'bar',
        barWidth: 18,
        itemStyle: {
          borderRadius: [0, 12, 12, 0],
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 1,
            y2: 0,
            colorStops: [
              { offset: 0, color: '#0f9d8a' },
              { offset: 1, color: '#58c4b4' },
            ],
          },
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: compareList.value.map((item) => Number(item.metricValue || 0)),
      },
    ],
  }
})

const yoyOption = computed(() => {
  if (!yoyComparison.value.length) {
    return { series: [] }
  }

  return {
    color: ['#b67bf0', '#0f9d8a'],
    tooltip: chartTooltipConfig('shadow'),
    legend: {
      top: 0,
      textStyle: { color: '#4a6670' },
    },
    grid: { top: 42, right: 18, bottom: 24, left: 46 },
    xAxis: {
      type: 'category',
      data: yoyComparison.value.map((item) => item.label),
      axisLabel: { interval: 0, color: '#4a6670' },
      axisLine: { lineStyle: { color: '#bdd0d6' } },
    },
    yAxis: {
      type: 'value',
      axisLabel: { formatter: '{value}%', color: '#4a6670' },
      splitLine: { lineStyle: { color: 'rgba(22,52,61,0.08)' } },
    },
    series: [
      {
        name: String(filters.year - 1),
        type: 'bar',
        barWidth: 18,
        itemStyle: {
          borderRadius: [10, 10, 0, 0],
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: '#d0a9ff' },
              { offset: 1, color: '#9b61e2' },
            ],
          },
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: yoyComparison.value.map((item) => item.previous),
      },
      {
        name: String(filters.year),
        type: 'bar',
        barWidth: 18,
        itemStyle: {
          borderRadius: [10, 10, 0, 0],
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: '#57c8b7' },
              { offset: 1, color: '#118779' },
            ],
          },
        },
        animationDuration: 900,
        animationDurationUpdate: 500,
        universalTransition: true,
        data: yoyComparison.value.map((item) => item.current),
      },
    ],
  }
})

function chartTooltipConfig(pointerType = 'line') {
  return {
    trigger: 'axis',
    axisPointer: { type: pointerType },
    backgroundColor: 'rgba(14, 34, 40, 0.92)',
    borderColor: 'rgba(255, 255, 255, 0.08)',
    textStyle: { color: '#f2fbfb' },
    extraCssText: 'box-shadow: 0 16px 40px rgba(8,24,29,0.18); border-radius: 14px;',
  }
}

function buildFilterPayload() {
  const payload = {}
  if (filters.deptId) {
    payload.deptId = filters.deptId
  }
  if (filters.majorId) {
    payload.majorId = filters.majorId
  }
  if (filters.year) {
    payload.year = filters.year
  }
  return payload
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

function resetFilters() {
  filters.deptId = null
  filters.majorId = null
  filters.year = currentYear
  filters.compareMetric = 'EMPLOYMENT_RATE'
  filters.trendMetric = 'ADMISSION_COMPLETION_RATE'
  filters.rankMetric = 'EMPLOYMENT_RATE'
  applyScopeDefaults()
}

async function loadOverview() {
  loading.overview = true
  try {
    overview.value = await fetchOverview(buildFilterPayload())
  } finally {
    loading.overview = false
  }
}

async function loadTrend() {
  loading.trend = true
  try {
    trendList.value = await fetchTrend({
      metric: filters.trendMetric,
      deptId: filters.deptId,
      majorId: filters.majorId,
      startYear: filters.year - 4,
      endYear: filters.year,
    })
  } finally {
    loading.trend = false
  }
}

async function loadRank() {
  loading.rank = true
  try {
    rankList.value = await fetchRank({
      metric: filters.rankMetric,
      deptId: filters.deptId,
      majorId: filters.majorId,
      year: filters.year,
      limit: 8,
    })
  } finally {
    loading.rank = false
  }
}

async function loadCompare() {
  loading.compare = true
  try {
    const [sameYearCompare, yoySeries] = await Promise.all([
      fetchRank({
        metric: filters.compareMetric,
        deptId: filters.deptId,
        majorId: filters.majorId,
        year: filters.year,
        limit: 8,
      }),
      Promise.all(
        METRIC_OPTIONS.map((item) =>
          fetchTrend({
            metric: item.value,
            deptId: filters.deptId,
            majorId: filters.majorId,
            startYear: filters.year - 1,
            endYear: filters.year,
          }),
        ),
      ),
    ])

    compareList.value = sameYearCompare
    yoyComparison.value = METRIC_OPTIONS.map((item, index) => {
      const points = yoySeries[index] || []
      const current = points.find((point) => Number(point.statYear) === Number(filters.year))
      const previous = points.find((point) => Number(point.statYear) === Number(filters.year - 1))
      return {
        label: item.label,
        current: Number(current?.metricValue || 0),
        previous: Number(previous?.metricValue || 0),
      }
    })
  } finally {
    loading.compare = false
  }
}

async function loadScores() {
  loading.score = true
  try {
    scoreList.value = await fetchScores(buildFilterPayload())
  } finally {
    loading.score = false
  }
}

async function loadWarnings() {
  loading.warning = true
  try {
    warningList.value = await fetchWarnings(buildFilterPayload())
  } finally {
    loading.warning = false
  }
}

async function loadDashboard() {
  await Promise.all([
    loadOverview(),
    loadTrend(),
    loadRank(),
    loadCompare(),
    loadScores(),
    loadWarnings(),
  ])
}

async function handleDashboardExport(command) {
  exporting.value = true
  try {
    const params = buildFilterPayload()
    if (command === 'major-summary') {
      await exportMajorSummary(params)
      ElMessage.success('专业总览导出成功')
      return
    }
    await exportAnnualIndicators(params)
    ElMessage.success('年度指标导出成功')
  } finally {
    exporting.value = false
  }
}

async function handleRecalculate() {
  recalculating.value = true
  try {
    await recalculateWarnings()
    ElMessage.success('预警重算完成')
    await loadWarnings()
  } finally {
    recalculating.value = false
  }
}

async function handleScopeRefresh() {
  await loadDashboard()
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
  await loadDashboard()
})
</script>

<template>
  <div class="page-shell dashboard-view">
    <section class="page-card dashboard-view__brief dashboard-fade-up" style="--enter-delay: 0ms;">
      <div class="dashboard-view__brief-main">
        <div>
          <span class="dashboard-view__brief-kicker">专业建设监测简报</span>
          <h2>首页看板</h2>
          <p class="dashboard-view__brief-copy">
            以图表切换方式展示专业建设的规模、评分、趋势与对比结果，方便答辩时按照统一口径逐组讲解。
          </p>
        </div>

        <div class="dashboard-view__brief-side">
          <el-dropdown v-if="canExportDashboard" trigger="click" @command="handleDashboardExport">
            <el-button :loading="exporting" plain>导出看板</el-button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="major-summary">导出专业总览</el-dropdown-item>
                <el-dropdown-item command="annual-indicators">导出年度指标</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>

          <div class="dashboard-view__champion-card">
            <span class="dashboard-view__champion-label">当前最佳专业</span>
            <template v-if="champion">
              <strong>{{ champion.majorName }}</strong>
              <span class="dashboard-view__champion-score">{{ Number(champion.totalScore || 0).toFixed(2) }}</span>
              <p>{{ championSummary }}</p>
            </template>
            <EmptyState v-else title="暂无综合评分" description="补充年度数据后可自动生成专业评分结果。" />
          </div>
        </div>
      </div>

      <div class="dashboard-view__scope-tags">
        <span v-for="tag in scopeTags" :key="tag" class="dashboard-view__scope-tag">{{ tag }}</span>
      </div>

      <div class="dashboard-view__brief-highlights">
        <div v-for="item in briefHighlights" :key="item.label" class="dashboard-view__brief-highlight">
          <span>{{ item.label }}</span>
          <strong>{{ item.value }}</strong>
        </div>
      </div>

      <div class="dashboard-view__filters-bar">
        <div class="dashboard-view__filters-title">
          <h3>展示筛选</h3>
          <p>切换学院、专业、年份和关键指标，统一作用于所有图表分组。</p>
        </div>
        <div class="dashboard-view__filters-grid">
          <el-form-item label="学院">
            <el-select
              v-model="filters.deptId"
              class="full-width"
              clearable
              :disabled="authStore.isDeptAdmin || authStore.isMajorAdmin"
              @change="handleScopeRefresh"
            >
              <el-option v-for="item in dictStore.departments" :key="item.deptId" :label="item.name" :value="item.deptId" />
            </el-select>
          </el-form-item>

          <el-form-item label="专业">
            <el-select v-model="filters.majorId" class="full-width" clearable :disabled="authStore.isMajorAdmin" @change="handleScopeRefresh">
              <el-option v-for="item in majorOptions" :key="item.majorId" :label="item.name" :value="item.majorId" />
            </el-select>
          </el-form-item>

          <el-form-item label="年份">
            <el-input-number v-model="filters.year" class="full-width" :min="2020" :max="2100" controls-position="right" @change="handleScopeRefresh" />
          </el-form-item>

          <el-form-item label="对比指标">
            <el-select v-model="filters.compareMetric" class="full-width" @change="loadCompare">
              <el-option v-for="item in METRIC_OPTIONS" :key="item.value" :label="item.label" :value="item.value" />
            </el-select>
          </el-form-item>
        </div>
        <div class="toolbar dashboard-view__filters-actions">
          <el-button type="primary" @click="loadDashboard">刷新看板</el-button>
          <el-button @click="resetFilters(); loadDashboard()">恢复默认</el-button>
        </div>
      </div>
    </section>

    <section class="dashboard-view__stage">
      <div class="dashboard-view__stage-main">
        <div class="page-card dashboard-view__stage-head dashboard-fade-up" style="--enter-delay: 80ms;">
          <div>
            <span class="dashboard-view__stage-kicker">图表分组</span>
            <h3>{{ activeGroupMeta.title }}</h3>
            <p>{{ activeGroupMeta.description }}</p>
          </div>
          <el-tag type="success" effect="plain">当前仅展示一组</el-tag>
        </div>

        <transition name="dashboard-stage" mode="out-in">
          <div :key="activeChartGroup" class="dashboard-view__group-stage dashboard-fade-up" style="--enter-delay: 120ms;">
            <section v-if="activeChartGroup === 'overview'" class="grid-two">
              <ChartPanel
                :loading="loading.overview"
                :option="resourceOverviewOption"
                title="资源规模图谱"
                subtitle="数量概览"
                description="用一组柱状图统一展示专业规模、师资、学生、竞赛成果和当前预警数量。"
                eyebrow="规模画像"
                accent="var(--brand-primary)"
                :height="330"
              />

              <div class="page-card dashboard-view__ring-panel">
                <div class="section-title">
                  <div>
                    <h3>关键比率环图</h3>
                    <p>以环图集中展示质量、执行与去向类百分比指标。</p>
                  </div>
                  <el-tag type="success" effect="plain">5 项核心指标</el-tag>
                </div>

                <div class="dashboard-view__ring-grid">
                  <MiniDonutChart
                    v-for="(item, index) in rateMetrics"
                    :key="item.label"
                    :title="item.label"
                    :value="item.value"
                    :accent="item.accent"
                    :hint="item.hint"
                    :delay="index * 40"
                  />
                </div>
              </div>
            </section>

            <section v-else-if="activeChartGroup === 'score-warning'" class="grid-two">
              <ChartPanel
                :loading="loading.score"
                :option="scoreRankingOption"
                title="综合评分排行"
                :subtitle="champion ? `冠军专业：${champion.majorName}` : '等待数据生成'"
                description="将综合评分直接图表化，突出答辩中最值得重点展示的专业。"
                eyebrow="评分排名"
                accent="#0f9d8a"
                :height="360"
              >
                <template #footer>
                  <div v-if="champion" class="dashboard-view__chart-note">
                    <strong>{{ champion.majorName }}</strong>
                    <span>就业率 {{ formatPercent(champion.employmentRate) }}，升学率 {{ formatPercent(champion.postgraduateRate) }}</span>
                  </div>
                </template>
              </ChartPanel>

              <ChartPanel
                :loading="loading.warning"
                :option="warningDistributionOption"
                title="预警分布与最新提醒"
                :subtitle="`活跃预警 ${topWarningCount} 条`"
                description="上半部分展示预警分布，下半部分展示最新预警摘要。"
                eyebrow="预警诊断"
                accent="#d64545"
                :height="280"
              >
                <template #extra>
                  <div class="toolbar">
                    <el-button v-if="authStore.isSchoolAdmin" type="danger" plain :loading="recalculating" @click="handleRecalculate">重算预警</el-button>
                  </div>
                </template>

                <template #footer>
                  <div v-if="warningPreview.length" class="dashboard-view__warning-feed">
                    <article
                      v-for="item in warningPreview"
                      :key="item.warningId || `${item.majorName}-${item.indicatorCode}-${item.statYear}`"
                      class="dashboard-view__warning-feed-item"
                    >
                      <div class="dashboard-view__warning-feed-head">
                        <strong>{{ item.indicatorName }}</strong>
                        <el-tag :type="STATUS_TAGS[item.status] || 'info'">{{ item.status }}</el-tag>
                      </div>
                      <p>{{ item.majorName }} · {{ item.statYear }} · {{ item.message }}</p>
                      <div class="dashboard-view__warning-feed-foot">
                        <span>实际值 {{ formatValue(item.actualValue) }}</span>
                        <span>{{ formatDateTime(item.triggeredAt) }}</span>
                      </div>
                    </article>
                  </div>
                  <EmptyState v-else title="当前没有预警" description="当前筛选范围内指标运行平稳。" />
                </template>
              </ChartPanel>
            </section>

            <section v-else-if="activeChartGroup === 'trend-rank'" class="grid-two">
              <ChartPanel
                :loading="loading.trend"
                :option="trendOption"
                title="趋势分析"
                :subtitle="metricLabelMap[filters.trendMetric]"
                description="默认展示近五年的关键指标变化趋势。"
                eyebrow="年度变化"
                accent="var(--brand-primary)"
                :height="340"
              >
                <template #extra>
                  <el-select v-model="filters.trendMetric" style="width: 190px;" @change="loadTrend">
                    <el-option v-for="item in METRIC_OPTIONS" :key="item.value" :label="item.label" :value="item.value" />
                  </el-select>
                </template>
              </ChartPanel>

              <ChartPanel
                :loading="loading.rank"
                :option="rankOption"
                title="专业排行对比"
                :subtitle="metricLabelMap[filters.rankMetric]"
                description="以柱状图快速呈现当前年份内各专业在核心指标上的相对位置。"
                eyebrow="横向排序"
                accent="var(--brand-accent)"
                :height="340"
              >
                <template #extra>
                  <el-select v-model="filters.rankMetric" style="width: 190px;" @change="loadRank">
                    <el-option v-for="item in METRIC_OPTIONS" :key="item.value" :label="item.label" :value="item.value" />
                  </el-select>
                </template>
              </ChartPanel>
            </section>

            <section v-else class="grid-two">
              <ChartPanel
                :loading="loading.compare"
                :option="compareOption"
                title="同年横向对比"
                :subtitle="metricLabelMap[filters.compareMetric]"
                description="同一年内不同专业在同一指标上的横向差异。"
                eyebrow="专业对比"
                accent="var(--brand-primary)"
                :height="340"
              />

              <ChartPanel
                :loading="loading.compare"
                :option="yoyOption"
                title="年度同比对比"
                :subtitle="`${filters.year - 1} vs ${filters.year}`"
                description="分组柱状图直接对比两年核心指标。"
                eyebrow="年度对照"
                accent="#8b5cf6"
                :height="340"
              />
            </section>
          </div>
        </transition>
      </div>

      <aside class="page-card dashboard-view__group-nav dashboard-fade-up" style="--enter-delay: 140ms;">
        <div class="dashboard-view__group-nav-head">
          <span>显示切换</span>
          <h4>选择图表组</h4>
          <p>每次只显示一组图表，方便投屏讲解。</p>
        </div>

        <button
          v-for="group in CHART_GROUPS"
          :key="group.key"
          type="button"
          class="dashboard-view__group-button"
          :class="{ 'is-active': activeChartGroup === group.key }"
          @click="activeChartGroup = group.key"
        >
          <strong>{{ group.title }}</strong>
          <span>{{ group.description }}</span>
        </button>
      </aside>
    </section>
  </div>
</template>

<style scoped>
.dashboard-view {
  display: grid;
  gap: 20px;
}

.dashboard-view__brief,
.dashboard-view__ring-panel,
.dashboard-view__stage-head,
.dashboard-view__group-nav {
  position: relative;
  overflow: hidden;
}

.dashboard-view__brief {
  padding: 24px;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.96), rgba(246, 251, 251, 0.84)),
    radial-gradient(circle at top left, rgba(15, 157, 138, 0.12), transparent 28%),
    radial-gradient(circle at top right, rgba(242, 155, 56, 0.1), transparent 22%);
}

.dashboard-view__brief::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    linear-gradient(120deg, transparent 0%, rgba(15, 157, 138, 0.03) 34%, transparent 60%),
    repeating-linear-gradient(90deg, transparent 0 28px, rgba(15, 157, 138, 0.03) 28px 29px);
  pointer-events: none;
}

.dashboard-view__brief-main,
.dashboard-view__scope-tags,
.dashboard-view__brief-highlights,
.dashboard-view__filters-bar {
  position: relative;
  z-index: 1;
}

.dashboard-view__brief-main {
  display: grid;
  grid-template-columns: minmax(0, 1.35fr) minmax(320px, 0.65fr);
  gap: 20px;
}

.dashboard-view__brief-side {
  display: flex;
  flex-direction: column;
  gap: 14px;
  align-items: flex-end;
}

.dashboard-view__brief-kicker,
.dashboard-view__stage-kicker {
  display: inline-flex;
  color: var(--text-muted);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.dashboard-view__brief-main h2 {
  margin: 12px 0 10px;
  font-size: 36px;
  line-height: 1.08;
}

.dashboard-view__brief-copy {
  max-width: 92%;
  margin: 0;
  color: var(--text-secondary);
  font-size: 15px;
  line-height: 1.8;
}

.dashboard-view__champion-card {
  width: 100%;
  min-height: 180px;
  padding: 20px;
  border: 1px solid rgba(15, 157, 138, 0.12);
  border-radius: 22px;
  background:
    linear-gradient(145deg, rgba(18, 66, 62, 0.96), rgba(18, 104, 92, 0.92)),
    radial-gradient(circle at top right, rgba(255, 255, 255, 0.12), transparent 24%);
  color: #f5fcfd;
  box-shadow: 0 16px 34px rgba(10, 38, 44, 0.16);
}

.dashboard-view__champion-label {
  display: inline-flex;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.1);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.dashboard-view__champion-card strong,
.dashboard-view__champion-score {
  display: block;
}

.dashboard-view__champion-card strong {
  margin-top: 16px;
  font-size: 28px;
}

.dashboard-view__champion-score {
  margin-top: 6px;
  font-size: 38px;
  font-weight: 900;
  letter-spacing: -0.04em;
}

.dashboard-view__champion-card p {
  margin: 12px 0 0;
  color: rgba(245, 252, 253, 0.84);
  line-height: 1.7;
}

.dashboard-view__scope-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 18px;
}

.dashboard-view__scope-tag {
  display: inline-flex;
  align-items: center;
  padding: 8px 12px;
  border: 1px solid rgba(15, 157, 138, 0.12);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.76);
  color: var(--text-secondary);
  font-size: 13px;
  font-weight: 600;
}

.dashboard-view__brief-highlights {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.dashboard-view__brief-highlight {
  padding: 14px 16px;
  border: 1px solid rgba(22, 52, 61, 0.08);
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.74);
}

.dashboard-view__brief-highlight span,
.dashboard-view__brief-highlight strong {
  display: block;
}

.dashboard-view__brief-highlight span {
  color: var(--text-muted);
  font-size: 13px;
}

.dashboard-view__brief-highlight strong {
  margin-top: 8px;
  font-size: 18px;
}

.dashboard-view__filters-bar {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 18px;
  margin-top: 20px;
  padding: 18px;
  border: 1px solid rgba(22, 52, 61, 0.08);
  border-radius: 22px;
  background: rgba(255, 255, 255, 0.78);
}

.dashboard-view__filters-title h3,
.dashboard-view__filters-title p {
  margin: 0;
}

.dashboard-view__filters-title p {
  margin-top: 6px;
  color: var(--text-secondary);
}

.dashboard-view__filters-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.dashboard-view__filters-actions {
  align-self: end;
}

.dashboard-view__stage {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 250px;
  gap: 20px;
  align-items: start;
}

.dashboard-view__stage-main {
  min-width: 0;
}

.dashboard-view__stage-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 20px 22px;
  margin-bottom: 18px;
}

.dashboard-view__stage-head h3,
.dashboard-view__stage-head p {
  margin: 0;
}

.dashboard-view__stage-head h3 {
  margin-top: 10px;
  font-size: 28px;
}

.dashboard-view__stage-head p {
  margin-top: 8px;
  color: var(--text-secondary);
}

.dashboard-view__group-stage {
  min-width: 0;
}

.dashboard-view__group-nav {
  position: sticky;
  top: 18px;
  padding: 18px;
}

.dashboard-view__group-nav-head {
  margin-bottom: 14px;
}

.dashboard-view__group-nav-head span {
  color: var(--text-muted);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.dashboard-view__group-nav-head h4,
.dashboard-view__group-nav-head p {
  margin: 0;
}

.dashboard-view__group-nav-head h4 {
  margin-top: 8px;
  font-size: 20px;
}

.dashboard-view__group-nav-head p {
  margin-top: 8px;
  color: var(--text-secondary);
  line-height: 1.7;
}

.dashboard-view__group-button {
  display: block;
  width: 100%;
  margin-top: 10px;
  padding: 16px;
  border: 1px solid rgba(22, 52, 61, 0.08);
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.76);
  text-align: left;
  cursor: pointer;
  transition:
    transform 200ms ease,
    border-color 200ms ease,
    box-shadow 200ms ease,
    background-color 200ms ease;
}

.dashboard-view__group-button strong,
.dashboard-view__group-button span {
  display: block;
}

.dashboard-view__group-button strong {
  color: var(--text-primary);
  font-size: 15px;
}

.dashboard-view__group-button span {
  margin-top: 8px;
  color: var(--text-muted);
  font-size: 12px;
  line-height: 1.6;
}

.dashboard-view__group-button:hover {
  transform: translateY(-2px);
  border-color: rgba(15, 157, 138, 0.2);
}

.dashboard-view__group-button.is-active {
  border-color: rgba(15, 157, 138, 0.26);
  background: linear-gradient(180deg, rgba(15, 157, 138, 0.12), rgba(15, 157, 138, 0.04));
  box-shadow: 0 14px 24px rgba(13, 56, 61, 0.1);
}

.dashboard-view__ring-panel {
  padding: 22px;
}

.dashboard-view__ring-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 14px;
}

.dashboard-view__chart-note {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 16px;
  border-radius: 16px;
  background: rgba(15, 157, 138, 0.08);
}

.dashboard-view__chart-note strong {
  font-size: 14px;
}

.dashboard-view__chart-note span {
  color: var(--text-secondary);
  font-size: 13px;
}

.dashboard-view__warning-feed {
  display: grid;
  gap: 12px;
}

.dashboard-view__warning-feed-item {
  padding: 16px;
  border: 1px solid rgba(22, 52, 61, 0.08);
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.74);
}

.dashboard-view__warning-feed-head,
.dashboard-view__warning-feed-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.dashboard-view__warning-feed-item p {
  margin: 10px 0;
  color: var(--text-secondary);
  line-height: 1.65;
}

.dashboard-view__warning-feed-foot {
  color: var(--text-muted);
  font-size: 12px;
}

.dashboard-stage-enter-active,
.dashboard-stage-leave-active {
  transition: opacity 220ms ease, transform 220ms ease;
}

.dashboard-stage-enter-from,
.dashboard-stage-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

@media (max-width: 1400px) {
  .dashboard-view__ring-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (max-width: 1280px) {
  .dashboard-view__brief-main,
  .dashboard-view__filters-bar,
  .dashboard-view__stage {
    grid-template-columns: 1fr;
  }

  .dashboard-view__brief-side {
    align-items: stretch;
  }

  .dashboard-view__group-nav {
    position: static;
    display: grid;
    grid-template-columns: repeat(4, minmax(180px, 1fr));
    gap: 12px;
  }

  .dashboard-view__group-nav-head {
    grid-column: 1 / -1;
    margin-bottom: 0;
  }

  .dashboard-view__group-button {
    margin-top: 0;
  }
}

@media (max-width: 1100px) {
  .dashboard-view__brief-highlights,
  .dashboard-view__filters-grid,
  .dashboard-view__ring-grid,
  .dashboard-view__group-nav {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 900px) {
  .dashboard-view__brief {
    padding: 20px;
  }

  .dashboard-view__brief-main h2 {
    font-size: 30px;
  }

  .dashboard-view__brief-copy {
    max-width: 100%;
  }

  .dashboard-view__brief-highlights,
  .dashboard-view__filters-grid,
  .dashboard-view__ring-grid,
  .dashboard-view__group-nav {
    grid-template-columns: 1fr;
  }

  .dashboard-view__stage-head,
  .dashboard-view__chart-note,
  .dashboard-view__warning-feed-head,
  .dashboard-view__warning-feed-foot {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
