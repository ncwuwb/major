<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useResizeObserver } from '@vueuse/core'
import * as echarts from 'echarts'

const props = defineProps({
  option: { type: Object, required: true },
  theme: { type: String, default: 'dark' },
})

const elRef = ref(null)
let instance = null
let pendingRender = false

const hasSeries = computed(() => Array.isArray(props.option?.series) && props.option.series.length > 0)

function hasSize() {
  const el = elRef.value
  return el && el.clientWidth > 0 && el.clientHeight > 0
}

const ECHARTS_TICK_WARN = 'ticks may be not readable'
function quietECharts(fn) {
  const origWarn = console.warn
  console.warn = (...args) => {
    if (typeof args[0] === 'string' && args[0].includes(ECHARTS_TICK_WARN)) return
    origWarn.apply(console, args)
  }
  try { fn() } finally { console.warn = origWarn }
}

function render() {
  if (!elRef.value || !hasSeries.value) return
  if (!hasSize()) {
    pendingRender = true
    return
  }
  pendingRender = false
  quietECharts(() => {
    if (!instance) {
      instance = echarts.init(elRef.value, props.theme)
    }
    instance.setOption(props.option, true)
  })
}

function resize() {
  if (pendingRender) {
    render()
    return
  }
  quietECharts(() => instance?.resize())
}

onMounted(() => nextTick(render))

watch(
  () => props.option,
  () => nextTick(render),
  { deep: true },
)

watch(hasSeries, (value) => {
  if (!value) instance?.clear()
})

useResizeObserver(elRef, resize)

onBeforeUnmount(() => {
  instance?.dispose()
  instance = null
})
</script>

<template>
  <div ref="elRef" class="bigscreen-chart"></div>
</template>

<style scoped>
.bigscreen-chart {
  width: 100%;
  height: 100%;
  min-height: 1px;
  flex: 1;
}
</style>

