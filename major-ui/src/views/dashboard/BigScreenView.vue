<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { useIntervalFn } from '@vueuse/core'
import { ElMessage } from 'element-plus'

import BigScreenChart from '@/components/bigscreen/BigScreenChart.vue'
import BigScreenPanel from '@/components/bigscreen/BigScreenPanel.vue'
import EmptyState from '@/components/common/EmptyState.vue'
import { fetchOverview, fetchRank, fetchTrend, fetchWarningMetrics, fetchWarnings } from '@/api/dashboard'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dicts'
import { formatPercent, formatValue } from '@/utils/format'

const authStore = useAuthStore()
const dictStore = useDictStore()

const currentYear = 2025
const loading = reactive({
  overview: false,
  trends: false,
  ranks: false,
  warnings: false,
})

const filters = reactive({
  deptId: null,
  majorId: null,
  year: currentYear,
})

const overview = ref({})
const warningList = ref([])
const warningMetrics = ref([])

const trendSeries = reactive({
  admissionCompletion: [],
  fundingUtilization: [],
  employmentRate: [],
  achievementCount: [],
  competitionCount: [],
})

const rankSeries = reactive({
  majorSetup: [],
  admission: [],
  teacher: [],
  course: [],
  achievement: [],
  employment: [],
  competition: [],
  funding: [],
})

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

function buildFilterPayload() {
  const payload = {}
  if (filters.deptId) payload.deptId = filters.deptId
  if (filters.majorId) payload.majorId = filters.majorId
  if (filters.year) payload.year = filters.year
  return payload
}

function buildTrendPayload() {
  const payload = {}
  if (filters.deptId) payload.deptId = filters.deptId
  if (filters.majorId) payload.majorId = filters.majorId
  return payload
}

const scopeTitle = computed(() => {
  const deptName = dictStore.departments.find((item) => Number(item.deptId) === Number(filters.deptId))?.name || '全校'
  const majorName = dictStore.majors.find((item) => Number(item.majorId) === Number(filters.majorId))?.name || '全部专业'
  return `${filters.year} · ${deptName} · ${majorName}`
})

const topWarnings = computed(() => warningList.value.slice(0, 6))
const activeWarningCount = computed(() => warningList.value.filter((item) => item.status === 'ACTIVE').length)

const kpis = computed(() => ([
  { label: '专业', value: Number(overview.value.majorCount || 0) },
  { label: '教师', value: Number(overview.value.teacherCount || 0) },
  { label: '学生', value: Number(overview.value.studentCount || 0) },
  { label: '课程', value: Number(overview.value.courseCount || 0) },
  { label: '成果', value: Number(overview.value.achievementCount || 0) },
  { label: '竞赛获奖', value: Number(overview.value.competitionAwardCount || 0) },
  { label: '活跃预警', value: Number(activeWarningCount.value || 0) },
]))

const qualityKpis = computed(() => ([
  { label: '博士占比', value: formatPercent(overview.value.phdRate) },
  { label: '招生完成率', value: formatPercent(overview.value.admissionCompletionRate) },
  { label: '经费使用率', value: formatPercent(overview.value.fundingUtilizationRate) },
  { label: '就业率', value: formatPercent(overview.value.employmentRate) },
  { label: '升学率', value: formatPercent(overview.value.postgraduateRate) },
  { label: '平均薪资', value: formatValue(overview.value.averageSalary) },
]))

async function loadOverview() {
  loading.overview = true
  try {
    overview.value = await fetchOverview(buildFilterPayload())
  } finally {
    loading.overview = false
  }
}

async function loadWarnings() {
  loading.warnings = true
  try {
    warningList.value = await fetchWarnings(buildFilterPayload())
  } finally {
    loading.warnings = false
  }
}

async function loadWarningMetrics() {
  try {
    warningMetrics.value = await fetchWarningMetrics(buildFilterPayload())
  } catch (e) {
    warningMetrics.value = []
  }
}

async function loadSingleTrend(metric, key) {
  try {
    const data = await fetchTrend({
      metric,
      deptId: filters.deptId || undefined,
      majorId: filters.majorId || undefined,
      startYear: filters.year - 4,
      endYear: filters.year,
    })
    trendSeries[key] = Array.isArray(data) ? data : []
  } catch (e) {
    console.warn(`[Trend] ${metric} failed:`, e?.message || e)
    trendSeries[key] = []
  }
}

async function loadTrends() {
  loading.trends = true
  try {
    await Promise.all([
      loadSingleTrend('ADMISSION_COMPLETION_RATE', 'admissionCompletion'),
      loadSingleTrend('FUNDING_UTILIZATION_RATE', 'fundingUtilization'),
      loadSingleTrend('EMPLOYMENT_RATE', 'employmentRate'),
      loadSingleTrend('ACHIEVEMENT_COUNT', 'achievementCount'),
      loadSingleTrend('COMPETITION_COUNT', 'competitionCount'),
    ])
  } catch (e) {
    console.warn('[Trend] loadTrends error:', e)
  } finally {
    loading.trends = false
  }
}

async function loadRanks() {
  loading.ranks = true
  try {
    const [
      majorSetup,
      admission,
      teacher,
      course,
      achievement,
      employment,
      competition,
      funding,
    ] = await Promise.all([
      fetchRank({ metric: 'STUDENT_COUNT', ...buildFilterPayload(), year: filters.year, limit: 8 }),
      fetchRank({ metric: 'ADMISSION_ACTUAL_TOTAL', ...buildFilterPayload(), year: filters.year, limit: 8 }),
      fetchRank({ metric: 'PHD_RATE', ...buildFilterPayload(), year: filters.year, limit: 8 }),
      fetchRank({ metric: 'COURSE_COUNT', ...buildFilterPayload(), year: filters.year, limit: 8 }),
      fetchRank({ metric: 'ACHIEVEMENT_COUNT', ...buildFilterPayload(), year: filters.year, limit: 8 }),
      fetchRank({ metric: 'EMPLOYMENT_RATE', ...buildFilterPayload(), year: filters.year, limit: 8 }),
      fetchRank({ metric: 'COMPETITION_COUNT', ...buildFilterPayload(), year: filters.year, limit: 8 }),
      fetchRank({ metric: 'FUNDING_SPENT_TOTAL', ...buildFilterPayload(), year: filters.year, limit: 8 }),
    ])
    rankSeries.majorSetup = majorSetup || []
    rankSeries.admission = admission || []
    rankSeries.teacher = teacher || []
    rankSeries.course = course || []
    rankSeries.achievement = achievement || []
    rankSeries.employment = employment || []
    rankSeries.competition = competition || []
    rankSeries.funding = funding || []
  } finally {
    loading.ranks = false
  }
}

async function loadAll(silent = false) {
  const results = await Promise.allSettled([
    loadOverview(),
    loadTrends(),
    loadRanks(),
    loadWarnings(),
    loadWarningMetrics(),
  ])
  const failures = results.filter((r) => r.status === 'rejected')
  if (failures.length && !silent) {
    console.warn('[Dashboard] Some loaders failed:', failures.map((f) => f.reason?.message || f.reason))
  }
}

const trendOption = computed(() => {
  const allYearsSet = new Set()
  Object.values(trendSeries).forEach((arr) => {
    (arr || []).forEach((p) => allYearsSet.add(p.statYear))
  })
  const years = Array.from(allYearsSet).sort((a, b) => a - b)
  if (!years.length) return { series: [] }

  function valuesForYears(arr) {
    const map = new Map((arr || []).map((p) => [p.statYear, Number(p.metricValue || 0)]))
    return years.map((y) => map.has(y) ? map.get(y) : null)
  }

  const maxCount = Math.max(
    0,
    ...trendSeries.achievementCount.map((p) => Number(p.metricValue || 0)),
    ...trendSeries.competitionCount.map((p) => Number(p.metricValue || 0)),
  )
  const countAxisMax = maxCount <= 0 ? 10 : Math.ceil(maxCount * 1.3)
  return {
    backgroundColor: 'transparent',
    tooltip: { trigger: 'axis' },
    grid: { top: 40, right: 14, bottom: 28, left: 44 },
    legend: { top: 8, textStyle: { color: 'rgba(226, 247, 255, 0.85)' } },
    xAxis: {
      type: 'category',
      data: years,
      axisLine: { lineStyle: { color: 'rgba(120,220,255,0.25)' } },
      axisLabel: { color: 'rgba(226, 247, 255, 0.75)' },
    },
    yAxis: [
      {
        type: 'value',
        alignTicks: false,
        axisLabel: { color: 'rgba(226, 247, 255, 0.75)' },
        splitLine: { lineStyle: { color: 'rgba(120,220,255,0.12)' } },
        min: 0,
        max: countAxisMax,
      },
      {
        type: 'value',
        alignTicks: false,
        axisLabel: { formatter: '{value}%', color: 'rgba(226, 247, 255, 0.75)' },
        splitLine: { show: false },
        min: 0,
        max: 100,
      },
    ],
    series: [
      {
        name: '就业率(%)',
        type: 'line',
        yAxisIndex: 1,
        smooth: true,
        symbolSize: 7,
        data: valuesForYears(trendSeries.employmentRate),
      },
      {
        name: '招生完成率(%)',
        type: 'line',
        yAxisIndex: 1,
        smooth: true,
        symbolSize: 7,
        data: valuesForYears(trendSeries.admissionCompletion),
      },
      {
        name: '经费使用率(%)',
        type: 'line',
        yAxisIndex: 1,
        smooth: true,
        symbolSize: 7,
        data: valuesForYears(trendSeries.fundingUtilization),
      },
      {
        name: '成果数',
        type: 'bar',
        yAxisIndex: 0,
        barWidth: 8,
        itemStyle: { opacity: 0.8 },
        data: valuesForYears(trendSeries.achievementCount),
      },
      {
        name: '竞赛数',
        type: 'bar',
        yAxisIndex: 0,
        barWidth: 8,
        itemStyle: { opacity: 0.8 },
        data: valuesForYears(trendSeries.competitionCount),
      },
    ],
  }
})

function buildRankBarOption(list = [], label, valueFormatter) {
  if (!list.length) return { series: [] }
  return {
    backgroundColor: 'transparent',
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' }, valueFormatter },
    grid: { top: 18, right: 12, bottom: 24, left: 110 },
    xAxis: {
      type: 'value',
      axisLabel: { color: 'rgba(226, 247, 255, 0.75)' },
      splitLine: { lineStyle: { color: 'rgba(120,220,255,0.12)' } },
    },
    yAxis: {
      type: 'category',
      inverse: true,
      data: list.map((i) => i.majorName),
      axisLine: { lineStyle: { color: 'rgba(120,220,255,0.25)' } },
      axisLabel: { color: 'rgba(226, 247, 255, 0.75)' },
    },
    series: [
      {
        name: label,
        type: 'bar',
        barWidth: 14,
        itemStyle: { borderRadius: [0, 8, 8, 0] },
        data: list.map((i) => Number(i.metricValue || 0)),
      },
    ],
  }
}

const rankMajorSetupOption = computed(() => buildRankBarOption(rankSeries.majorSetup, '学生规模'))
const rankAdmissionOption = computed(() => buildRankBarOption(rankSeries.admission, '实招人数'))
const rankTeacherOption = computed(() => buildRankBarOption(rankSeries.teacher, '博士占比', (v) => `${v}%`))
const rankCourseOption = computed(() => buildRankBarOption(rankSeries.course, '课程数'))
const rankAchievementOption = computed(() => buildRankBarOption(rankSeries.achievement, '成果数'))
const rankEmploymentOption = computed(() => buildRankBarOption(rankSeries.employment, '就业率', (v) => `${v}%`))
const rankCompetitionOption = computed(() => buildRankBarOption(rankSeries.competition, '竞赛数'))
const rankFundingOption = computed(() => buildRankBarOption(rankSeries.funding, '经费支出'))

const gaugeOptions = computed(() => {
  return (warningMetrics.value || []).map((item) => {
    const value = Number(item.attainmentRate || 0)
    const isWarn = item.status === 'WARN'
    return {
      indicatorCode: item.indicatorCode,
      indicatorName: item.indicatorName,
      status: item.status,
      option: {
        backgroundColor: 'transparent',
        series: [
          {
            type: 'gauge',
            startAngle: 210,
            endAngle: -30,
            min: 0,
            max: 200,
            splitNumber: 5,
            axisLine: {
              lineStyle: {
                width: 10,
                color: [
                  [0.5, 'rgba(251,113,133,0.65)'],
                  [1, 'rgba(34,197,94,0.75)'],
                ],
              },
            },
            center: ['50%', '58%'],
            radius: '92%',
            axisTick: { show: false },
            splitLine: { show: false },
            axisLabel: { show: false },
            pointer: { width: 3, length: '58%' },
            detail: {
              valueAnimation: true,
              formatter: '{value}%',
              color: isWarn ? 'rgba(251,113,133,0.95)' : 'rgba(34,197,94,0.95)',
              fontSize: 13,
              offsetCenter: [0, '18%'],
            },
            title: { show: false },
            data: [{ value }],
          },
        ],
      },
    }
  })
})

const radarOption = computed(() => {
  if (!warningMetrics.value?.length) return { series: [] }
  const values = warningMetrics.value.map((item) => Number(item.attainmentRate || 0))
  const radarMax = Math.ceil(Math.max(150, ...values) * 1.15 / 50) * 50
  const indicators = warningMetrics.value.map((item) => ({
    name: item.indicatorName,
    max: radarMax,
  }))
  return {
    backgroundColor: 'transparent',
    tooltip: { trigger: 'item' },
    radar: {
      indicator: indicators,
      radius: '62%',
      splitNumber: 5,
      axisName: { color: 'rgba(226, 247, 255, 0.78)', fontSize: 11 },
      splitLine: { lineStyle: { color: 'rgba(120,220,255,0.14)' } },
      splitArea: { areaStyle: { color: ['rgba(255,255,255,0.02)', 'rgba(255,255,255,0.01)'] } },
      axisLine: { lineStyle: { color: 'rgba(120,220,255,0.18)' } },
    },
    series: [
      {
        type: 'radar',
        data: [
          {
            value: values,
            name: '达标率(相对阈值)',
            areaStyle: { color: 'rgba(56,189,248,0.16)' },
            lineStyle: { color: 'rgba(56,189,248,0.85)', width: 2 },
            itemStyle: { color: 'rgba(56,189,248,0.95)' },
          },
        ],
      },
    ],
  }
})

const warningHeatmapOption = computed(() => {
  const list = warningList.value || []
  if (!list.length) return { series: [] }
  const indicators = Array.from(new Set(list.map((i) => i.indicatorName))).slice(0, 8)
  const majors = Array.from(new Set(list.map((i) => i.majorName))).slice(0, 10)
  const data = []
  majors.forEach((mName, y) => {
    indicators.forEach((iName, x) => {
      const hit = list.some((w) => w.majorName === mName && w.indicatorName === iName)
      data.push([x, y, hit ? 1 : 0])
    })
  })
  return {
    backgroundColor: 'transparent',
    tooltip: { formatter: (p) => `${indicators[p.data[0]]}<br/>${majors[p.data[1]]}<br/>预警：${p.data[2] ? '是' : '否'}` },
    grid: { top: 10, right: 10, bottom: 28, left: 90 },
    xAxis: {
      type: 'category',
      data: indicators,
      axisLabel: { color: 'rgba(226,247,255,0.72)', interval: 0, rotate: 20 },
      axisLine: { lineStyle: { color: 'rgba(120,220,255,0.22)' } },
    },
    yAxis: {
      type: 'category',
      data: majors,
      axisLabel: { color: 'rgba(226,247,255,0.72)' },
      axisLine: { lineStyle: { color: 'rgba(120,220,255,0.22)' } },
    },
    visualMap: {
      show: false,
      min: 0,
      max: 1,
      inRange: { color: ['rgba(34,197,94,0.14)', 'rgba(251,113,133,0.85)'] },
    },
    series: [
      {
        type: 'heatmap',
        data,
        label: { show: false },
        emphasis: { itemStyle: { shadowBlur: 8, shadowColor: 'rgba(0,0,0,0.35)' } },
      },
    ],
  }
})

const refreshMs = 30_000
const { pause, resume } = useIntervalFn(() => loadAll(true), refreshMs, { immediate: false })

onMounted(async () => {
  applyScopeDefaults()
  await loadAll()
  resume()
})

onBeforeUnmount(() => {
  pause()
})
</script>

<template>
  <div class="bigscreen">
    <header class="bigscreen__top">
      <div class="bigscreen__brand">
        <strong>高校专业数据资源监测平台</strong>
        <span class="muted">实时采集 · 阈值预警 · 趋势对比 · 质量评估</span>
      </div>
      <div class="bigscreen__meta">
        <div class="bigscreen__controls">
          <el-form inline class="bigscreen__control-form">
            <el-form-item label="学院">
              <el-select
                v-model="filters.deptId"
                style="width: 160px"
                clearable
                :disabled="authStore.isDeptAdmin || authStore.isMajorAdmin"
                @change="loadAll"
              >
                <el-option v-for="item in dictStore.departments" :key="item.deptId" :label="item.name" :value="item.deptId" />
              </el-select>
            </el-form-item>
            <el-form-item label="专业">
              <el-select
                v-model="filters.majorId"
                style="width: 180px"
                clearable
                :disabled="authStore.isMajorAdmin"
                @change="loadAll"
              >
                <el-option
                  v-for="item in (filters.deptId ? dictStore.majors.filter((m) => m.deptId === filters.deptId) : dictStore.majors)"
                  :key="item.majorId"
                  :label="item.name"
                  :value="item.majorId"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="年份">
              <el-input-number
                v-model="filters.year"
                :min="2020"
                :max="2100"
                controls-position="right"
                style="width: 140px"
                @change="loadAll"
              />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" plain @click="loadAll">刷新</el-button>
              <el-button plain @click="$router.push('/bigscreen')">全屏</el-button>
            </el-form-item>
          </el-form>
        </div>
        <el-tag type="success" effect="dark">{{ scopeTitle }}</el-tag>
        <el-tag type="danger" effect="dark">活跃预警 {{ activeWarningCount }} 条</el-tag>
        <el-tag effect="dark">{{ authStore.roleCode }}</el-tag>
      </div>
    </header>

    <section class="bigscreen__kpi-row">
      <div v-for="item in kpis" :key="item.label" class="bigscreen-kpi">
        <span>{{ item.label }}</span>
        <strong>{{ item.value }}</strong>
      </div>
      <div class="bigscreen-kpi bigscreen-kpi--wide">
        <div class="bigscreen-kpi__grid">
          <div v-for="item in qualityKpis" :key="item.label" class="bigscreen-kpi__cell">
            <span>{{ item.label }}</span>
            <strong>{{ item.value }}</strong>
          </div>
        </div>
      </div>
    </section>

    <main class="bigscreen__grid">
      <BigScreenPanel title="多维趋势（近五年）" subtitle="招生 / 经费 / 就业 / 成果 / 竞赛" accent="#38bdf8">
        <div class="bigscreen__chart-lg">
          <BigScreenChart v-if="trendOption.series?.length" :option="trendOption" />
          <EmptyState v-else title="暂无趋势数据" description="请补充年度业务数据或调整筛选范围。" />
        </div>
      </BigScreenPanel>

      <aside class="bigscreen__right">
        <BigScreenPanel title="预警诊断" subtitle="阈值仪表盘 / 雷达 / 热力" accent="#fb7185">
          <div class="bigscreen__warning-diagnose">
            <div class="bigscreen__gauge-grid">
              <div v-for="item in gaugeOptions" :key="item.indicatorCode" class="bigscreen__gauge-item">
                <div class="bigscreen__gauge-title">
                  <strong>{{ item.indicatorName }}</strong>
                  <span :class="['bigscreen__pill', item.status === 'WARN' ? 'is-warn' : 'is-pass']">{{ item.status === 'WARN' ? '预警' : '达标' }}</span>
                </div>
                <div class="bigscreen__gauge-chart">
                  <BigScreenChart :option="item.option" />
                </div>
              </div>
            </div>

            <div class="bigscreen__diag-bottom">
              <div class="bigscreen__radar">
                <BigScreenChart v-if="radarOption.series?.length" :option="radarOption" />
                <EmptyState v-else title="暂无阈值数据" description="请在“指标规则”中配置并启用阈值。" />
              </div>
              <div class="bigscreen__heatmap">
                <BigScreenChart v-if="warningHeatmapOption.series?.length" :option="warningHeatmapOption" />
                <EmptyState v-else title="暂无预警热力图" description="当前范围没有活跃预警。" />
              </div>
            </div>
          </div>
        </BigScreenPanel>

        <div class="bigscreen__rank-grid">
          <BigScreenPanel title="专业开设" subtitle="学生规模 TOP 8" accent="#22c55e">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankMajorSetupOption.series?.length" :option="rankMajorSetupOption" />
              <EmptyState v-else title="暂无数据" description="请补充学生数据。" />
            </div>
          </BigScreenPanel>

          <BigScreenPanel title="招生录取" subtitle="实招人数 TOP 8" accent="#38bdf8">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankAdmissionOption.series?.length" :option="rankAdmissionOption" />
              <EmptyState v-else title="暂无数据" description="请补充招生数据。" />
            </div>
          </BigScreenPanel>

          <BigScreenPanel title="师资队伍" subtitle="博士占比 TOP 8" accent="#a78bfa">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankTeacherOption.series?.length" :option="rankTeacherOption" />
              <EmptyState v-else title="暂无数据" description="请补充教师数据。" />
            </div>
          </BigScreenPanel>

          <BigScreenPanel title="课程建设" subtitle="课程数 TOP 8" accent="#f59e0b">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankCourseOption.series?.length" :option="rankCourseOption" />
              <EmptyState v-else title="暂无数据" description="请补充课程数据。" />
            </div>
          </BigScreenPanel>

          <BigScreenPanel title="教学成果" subtitle="成果数 TOP 8" accent="#f97316">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankAchievementOption.series?.length" :option="rankAchievementOption" />
              <EmptyState v-else title="暂无数据" description="请补充成果数据。" />
            </div>
          </BigScreenPanel>

          <BigScreenPanel title="就业升学" subtitle="就业率 TOP 8" accent="#10b981">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankEmploymentOption.series?.length" :option="rankEmploymentOption" />
              <EmptyState v-else title="暂无数据" description="请补充毕业去向数据。" />
            </div>
          </BigScreenPanel>

          <BigScreenPanel title="学科竞赛" subtitle="竞赛数 TOP 8" accent="#fb7185">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankCompetitionOption.series?.length" :option="rankCompetitionOption" />
              <EmptyState v-else title="暂无数据" description="请补充竞赛数据。" />
            </div>
          </BigScreenPanel>

          <BigScreenPanel title="经费使用" subtitle="支出 TOP 8" accent="#fbbf24">
            <div class="bigscreen__chart-sm">
              <BigScreenChart v-if="rankFundingOption.series?.length" :option="rankFundingOption" />
              <EmptyState v-else title="暂无数据" description="请补充经费数据。" />
            </div>
          </BigScreenPanel>
        </div>
      </aside>
    </main>
  </div>
</template>

<style scoped>
.bigscreen {
  min-height: 100vh;
  padding: 18px 18px 22px;
  background:
    radial-gradient(circle at 20% 10%, rgba(56, 189, 248, 0.22), transparent 42%),
    radial-gradient(circle at 80% 12%, rgba(34, 197, 94, 0.18), transparent 40%),
    radial-gradient(circle at 70% 78%, rgba(167, 139, 250, 0.16), transparent 46%),
    linear-gradient(180deg, #050b12, #050914 40%, #040a10);
  color: rgba(240, 251, 255, 0.92);
}

.bigscreen__top {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  padding-bottom: 14px;
  border-bottom: 1px solid rgba(120, 220, 255, 0.14);
  margin-bottom: 14px;
}

.bigscreen__brand strong {
  display: block;
  font-size: 22px;
  letter-spacing: 0.08em;
}

.bigscreen__brand span {
  display: block;
  margin-top: 6px;
}

.bigscreen__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  justify-content: flex-end;
  align-items: flex-end;
}

.bigscreen__controls {
  width: 100%;
  display: flex;
  justify-content: flex-end;
}

.bigscreen__control-form :deep(.el-form-item__label) {
  color: rgba(226, 247, 255, 0.75);
}

.bigscreen__control-form :deep(.el-input__wrapper),
.bigscreen__control-form :deep(.el-select__wrapper) {
  background: rgba(255, 255, 255, 0.06);
  box-shadow: none;
}

.bigscreen__control-form :deep(.el-input__inner) {
  color: rgba(240, 251, 255, 0.92);
}

.bigscreen__kpi-row {
  display: grid;
  grid-template-columns: repeat(7, minmax(0, 1fr)) minmax(340px, 1.4fr);
  gap: 12px;
  margin-bottom: 12px;
}

.bigscreen-kpi {
  border-radius: 18px;
  border: 1px solid rgba(120, 220, 255, 0.14);
  background: linear-gradient(180deg, rgba(10, 22, 34, 0.78), rgba(6, 14, 22, 0.68));
  padding: 12px 14px;
}

.bigscreen-kpi span {
  display: block;
  color: rgba(226, 247, 255, 0.72);
  font-size: 12px;
  letter-spacing: 0.08em;
}

.bigscreen-kpi strong {
  display: block;
  margin-top: 10px;
  font-size: 26px;
  font-weight: 900;
  letter-spacing: -0.02em;
}

.bigscreen-kpi--wide {
  padding: 10px 12px;
}

.bigscreen-kpi__grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
}

.bigscreen-kpi__cell {
  padding: 10px 10px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(120, 220, 255, 0.08);
}

.bigscreen-kpi__cell span {
  font-size: 12px;
}

.bigscreen-kpi__cell strong {
  font-size: 18px;
  margin-top: 8px;
}

.bigscreen__grid {
  display: grid;
  grid-template-columns: minmax(0, 1.65fr) minmax(0, 1fr);
  gap: 12px;
}

.bigscreen__right {
  display: grid;
  grid-template-rows: 1.2fr auto;
  gap: 12px;
  min-height: 0;
}

.bigscreen__rank-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.bigscreen__chart-lg {
  flex: 1;
  min-height: 320px;
  position: relative;
}

.bigscreen__chart-sm {
  height: 200px;
}

.bigscreen__warning-list {
  display: grid;
  gap: 10px;
}

.bigscreen__warning-diagnose {
  display: grid;
  gap: 12px;
}

.bigscreen__gauge-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 10px;
}

.bigscreen__gauge-item {
  display: flex;
  flex-direction: column;
  padding: 10px 10px 12px;
  border-radius: 14px;
  border: 1px solid rgba(120, 220, 255, 0.1);
  background: rgba(255, 255, 255, 0.03);
}

.bigscreen__gauge-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  min-height: 34px;
}

.bigscreen__gauge-title strong {
  font-size: 12px;
  color: rgba(240, 251, 255, 0.9);
  flex: 1;
  min-width: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.bigscreen__pill {
  display: inline-flex;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
}

.bigscreen__pill.is-warn {
  background: rgba(251, 113, 133, 0.18);
  color: rgba(251, 113, 133, 0.95);
}

.bigscreen__pill.is-pass {
  background: rgba(34, 197, 94, 0.14);
  color: rgba(34, 197, 94, 0.95);
}

.bigscreen__gauge-chart {
  margin-top: 8px;
  height: 132px;
  flex: 1;
  min-height: 132px;
  display: flex;
  align-items: center;
}

.bigscreen__diag-bottom {
  display: grid;
  grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
  gap: 12px;
  align-items: stretch;
}

.bigscreen__radar,
.bigscreen__heatmap {
  height: 220px;
}

.bigscreen__warning-item {
  border-radius: 14px;
  border: 1px solid rgba(251, 113, 133, 0.18);
  background: rgba(255, 255, 255, 0.03);
  padding: 10px 12px;
}

.bigscreen__warning-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 10px;
}

.bigscreen__warning-body {
  margin-top: 8px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.bigscreen__warning-msg {
  color: rgba(240, 251, 255, 0.86);
  line-height: 1.45;
}

.bigscreen__warning-val {
  color: rgba(226, 247, 255, 0.72);
  font-size: 12px;
}

@media (max-width: 1400px) {
  .bigscreen__grid {
    grid-template-columns: 1fr;
  }
  .bigscreen__rank-grid {
    grid-template-columns: 1fr;
  }
  .bigscreen__gauge-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .bigscreen__diag-bottom {
    grid-template-columns: 1fr;
  }
  .bigscreen__kpi-row {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .bigscreen__chart-lg {
    min-height: 360px;
    flex: 1;
  }
}
</style>

