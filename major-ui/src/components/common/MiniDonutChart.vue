<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useResizeObserver } from '@vueuse/core'
import * as echarts from 'echarts'

const props = defineProps({
  title: { type: String, required: true },
  value: { type: Number, default: 0 },
  accent: { type: String, default: '#0f9d8a' },
  hint: { type: String, default: '' },
  delay: { type: Number, default: 0 },
})

const chartRef = ref(null)
let chartInstance = null

const normalizedValue = computed(() => {
  const numericValue = Number(props.value || 0)
  if (!Number.isFinite(numericValue)) {
    return 0
  }
  return Math.max(0, Math.min(100, numericValue))
})

const option = computed(() => ({
  animationDuration: 900,
  animationDurationUpdate: 500,
  series: [
    {
      type: 'pie',
      radius: ['70%', '88%'],
      center: ['50%', '48%'],
      silent: true,
      label: { show: false },
      data: [
        {
          value: normalizedValue.value,
          itemStyle: {
            color: props.accent,
            shadowBlur: 14,
            shadowColor: `${props.accent}40`,
          },
        },
        {
          value: Math.max(0, 100 - normalizedValue.value),
          itemStyle: {
            color: 'rgba(22, 52, 61, 0.08)',
          },
        },
      ],
    },
  ],
  graphic: [
    {
      type: 'text',
      left: 'center',
      top: '34%',
      style: {
        text: `${normalizedValue.value.toFixed(1)}%`,
        fill: '#17343d',
        fontSize: 18,
        fontWeight: 800,
      },
    },
  ],
}))

function renderChart() {
  if (!chartRef.value) {
    return
  }

  if (!chartInstance) {
    chartInstance = echarts.init(chartRef.value)
  }

  chartInstance.setOption(option.value, true)
}

function resizeChart() {
  chartInstance?.resize()
}

onMounted(() => {
  nextTick(renderChart)
})

watch(option, () => {
  nextTick(renderChart)
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
  <article class="mini-donut dashboard-fade-up" :style="{ '--enter-delay': `${delay}ms` }">
    <div ref="chartRef" class="mini-donut__canvas"></div>
    <div class="mini-donut__meta">
      <strong>{{ title }}</strong>
      <span>{{ hint }}</span>
    </div>
  </article>
</template>

<style scoped>
.mini-donut {
  padding: 18px 16px;
  border: 1px solid rgba(22, 52, 61, 0.08);
  border-radius: 22px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(244, 249, 250, 0.84));
  box-shadow: 0 16px 32px rgba(13, 56, 61, 0.08);
  transition:
    transform 220ms ease,
    box-shadow 220ms ease,
    border-color 220ms ease;
}

.mini-donut:hover {
  transform: translateY(-3px);
  border-color: rgba(15, 157, 138, 0.16);
  box-shadow: 0 20px 36px rgba(13, 56, 61, 0.12);
}

.mini-donut__canvas {
  width: 100%;
  height: 132px;
}

.mini-donut__meta {
  margin-top: 8px;
}

.mini-donut__meta strong,
.mini-donut__meta span {
  display: block;
}

.mini-donut__meta strong {
  font-size: 14px;
}

.mini-donut__meta span {
  margin-top: 6px;
  color: var(--text-muted);
  font-size: 12px;
  line-height: 1.6;
}
</style>
