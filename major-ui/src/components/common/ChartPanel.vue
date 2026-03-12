<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useResizeObserver } from '@vueuse/core'
import * as echarts from 'echarts'

import EmptyState from '@/components/common/EmptyState.vue'

const props = defineProps({
  title: { type: String, required: true },
  subtitle: { type: String, default: '' },
  description: { type: String, default: '' },
  option: { type: Object, default: null },
  loading: { type: Boolean, default: false },
  height: { type: Number, default: 320 },
  emptyText: { type: String, default: '暂无图表数据' },
  eyebrow: { type: String, default: '图表分析' },
  accent: { type: String, default: 'var(--brand-primary)' },
  delay: { type: Number, default: 0 },
})

const chartRef = ref(null)
let chartInstance = null

const hasSeries = computed(() => Array.isArray(props.option?.series) && props.option.series.length > 0)

function renderChart() {
  if (!chartRef.value || !props.option || !hasSeries.value) {
    return
  }
  if (!chartInstance) {
    chartInstance = echarts.init(chartRef.value)
  }
  chartInstance.setOption(props.option, true)
}

function resizeChart() {
  chartInstance?.resize()
}

onMounted(() => {
  nextTick(renderChart)
})

watch(
  () => props.option,
  () => {
    nextTick(renderChart)
  },
  { deep: true },
)

watch(hasSeries, (value) => {
  if (!value) {
    chartInstance?.clear()
  }
})

useResizeObserver(chartRef, () => {
  resizeChart()
})

onBeforeUnmount(() => {
  chartInstance?.dispose()
  chartInstance = null
})
</script>

<template>
  <div
    class="chart-panel page-card dashboard-fade-up"
    :style="{
      '--accent-color': accent,
      '--enter-delay': `${delay}ms`,
    }"
  >
    <div class="chart-panel__glow"></div>
    <div class="chart-panel__header section-title">
      <div>
        <span class="chart-panel__eyebrow">{{ eyebrow }}</span>
        <div class="chart-panel__heading-row">
          <h3>{{ title }}</h3>
          <span v-if="subtitle" class="chart-panel__subtitle">{{ subtitle }}</span>
        </div>
        <p v-if="description">{{ description }}</p>
      </div>
      <div class="chart-panel__extra">
        <slot name="extra">
          <el-tag type="success" effect="plain">图表展示</el-tag>
        </slot>
      </div>
    </div>

    <slot name="before" />

    <el-skeleton :loading="loading" animated>
      <template #template>
        <el-skeleton-item variant="rect" :style="{ height: `${height}px`, borderRadius: '18px' }" />
      </template>

      <div v-if="hasSeries" ref="chartRef" class="chart-panel__chart" :style="{ height: `${height}px` }"></div>
      <slot v-else name="empty">
        <EmptyState :title="emptyText" description="可以切换年份、学院或专业后重试。" />
      </slot>
    </el-skeleton>

    <div v-if="$slots.footer && !loading && hasSeries" class="chart-panel__footer">
      <slot name="footer" />
    </div>
  </div>
</template>

<style scoped>
.chart-panel {
  position: relative;
  overflow: hidden;
  padding: 22px;
  transition:
    transform 220ms ease,
    box-shadow 220ms ease,
    border-color 220ms ease;
}

.chart-panel::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(246, 250, 251, 0.78)),
    radial-gradient(circle at top right, color-mix(in srgb, var(--accent-color) 10%, white) 0%, transparent 26%);
  pointer-events: none;
}

.chart-panel:hover {
  transform: translateY(-4px);
  border-color: color-mix(in srgb, var(--accent-color) 22%, var(--line-soft));
  box-shadow: 0 22px 44px rgba(13, 56, 61, 0.14);
}

.chart-panel__glow,
.chart-panel__header,
.chart-panel__chart,
.chart-panel__footer {
  position: relative;
  z-index: 1;
}

.chart-panel__glow {
  position: absolute;
  inset: auto -48px -54px auto;
  width: 170px;
  height: 170px;
  border-radius: 50%;
  background: radial-gradient(circle, color-mix(in srgb, var(--accent-color) 18%, white) 0%, transparent 72%);
  pointer-events: none;
}

.chart-panel__header {
  align-items: flex-start;
  margin-bottom: 18px;
}

.chart-panel__heading-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.chart-panel__eyebrow {
  display: inline-flex;
  margin-bottom: 10px;
  color: var(--text-muted);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.chart-panel__subtitle {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(15, 157, 138, 0.08);
  color: var(--brand-primary-deep);
  font-size: 12px;
  font-weight: 700;
}

.chart-panel__extra {
  display: flex;
  align-items: center;
  gap: 10px;
}

.chart-panel__chart {
  border-radius: 18px;
}

.chart-panel__footer {
  margin-top: 16px;
}

@media (max-width: 900px) {
  .chart-panel__heading-row {
    align-items: flex-start;
  }
}
</style>

