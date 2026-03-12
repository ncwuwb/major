<script setup>
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { usePreferredReducedMotion } from '@vueuse/core'

const props = defineProps({
  title: { type: String, required: true },
  value: { type: [String, Number], default: '--' },
  numericValue: { type: Number, default: null },
  suffix: { type: String, default: '' },
  hint: { type: String, default: '' },
  accent: { type: String, default: 'var(--brand-primary)' },
  icon: { type: String, default: 'MA' },
  eyebrow: { type: String, default: '核心指标' },
  delay: { type: Number, default: 0 },
  animated: { type: Boolean, default: true },
  decimals: { type: Number, default: 0 },
})

const reducedMotion = usePreferredReducedMotion()
const animatedNumber = ref(0)
let frameId = 0

const hasNumericValue = computed(
  () => props.numericValue !== null && props.numericValue !== undefined && props.numericValue !== '',
)

function stopAnimation() {
  if (frameId) {
    cancelAnimationFrame(frameId)
    frameId = 0
  }
}

function animateTo(target) {
  stopAnimation()

  if (!Number.isFinite(target)) {
    animatedNumber.value = 0
    return
  }

  if (!props.animated || reducedMotion.value === 'reduce') {
    animatedNumber.value = target
    return
  }

  const start = animatedNumber.value || 0
  const delta = target - start
  const duration = 900
  const startTime = performance.now()

  const tick = (now) => {
    const progress = Math.min((now - startTime) / duration, 1)
    const eased = 1 - Math.pow(1 - progress, 3)
    animatedNumber.value = start + delta * eased
    if (progress < 1) {
      frameId = requestAnimationFrame(tick)
    }
  }

  frameId = requestAnimationFrame(tick)
}

watch(
  () => props.numericValue,
  (value) => {
    if (value === null || value === undefined || value === '') {
      animatedNumber.value = 0
      return
    }
    animateTo(Number(value))
  },
  { immediate: true },
)

watch(
  () => reducedMotion.value,
  () => {
    if (hasNumericValue.value) {
      animateTo(Number(props.numericValue))
    }
  },
)

const displayValue = computed(() => {
  if (!hasNumericValue.value) {
    return props.value
  }
  return `${animatedNumber.value.toLocaleString('zh-CN', {
    minimumFractionDigits: props.decimals,
    maximumFractionDigits: props.decimals,
  })}${props.suffix}`
})

onBeforeUnmount(() => {
  stopAnimation()
})
</script>

<template>
  <div
    class="stats-card page-card dashboard-fade-up"
    :style="{
      '--accent-color': accent,
      '--enter-delay': `${delay}ms`,
    }"
  >
    <div class="stats-card__topline"></div>
    <div class="stats-card__meta-row">
      <span class="stats-card__eyebrow">{{ eyebrow }}</span>
      <span class="stats-card__orb"></span>
    </div>

    <div class="stats-card__meta">
      <span class="stats-card__icon">{{ icon }}</span>
      <span class="stats-card__title">{{ title }}</span>
    </div>

    <div class="stats-card__value">
      <span>{{ displayValue }}</span>
    </div>

    <p class="stats-card__hint">{{ hint }}</p>
  </div>
</template>

<style scoped>
.stats-card {
  position: relative;
  overflow: hidden;
  min-height: 190px;
  padding: 22px;
  transition:
    transform 220ms ease,
    box-shadow 220ms ease,
    border-color 220ms ease;
}

.stats-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    radial-gradient(circle at top right, color-mix(in srgb, var(--accent-color) 20%, white) 0%, transparent 32%),
    linear-gradient(145deg, rgba(255, 255, 255, 0.82), rgba(255, 255, 255, 0.62));
  pointer-events: none;
}

.stats-card::after {
  content: '';
  position: absolute;
  inset: auto -30px -36px auto;
  width: 132px;
  height: 132px;
  border-radius: 50%;
  background: radial-gradient(circle, color-mix(in srgb, var(--accent-color) 34%, white) 0%, transparent 70%);
  opacity: 0.9;
}

.stats-card:hover {
  transform: translateY(-4px);
  border-color: color-mix(in srgb, var(--accent-color) 26%, var(--line-soft));
  box-shadow: 0 22px 44px rgba(13, 56, 61, 0.14);
}

.stats-card__topline {
  position: absolute;
  inset: 0 auto auto 0;
  width: 100%;
  height: 4px;
  background: linear-gradient(90deg, var(--accent-color), color-mix(in srgb, var(--accent-color) 24%, white));
}

.stats-card__meta-row,
.stats-card__meta,
.stats-card__value,
.stats-card__hint {
  position: relative;
  z-index: 1;
}

.stats-card__meta-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.stats-card__eyebrow {
  color: var(--text-muted);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.stats-card__orb {
  display: inline-flex;
  width: 10px;
  height: 10px;
  border-radius: 999px;
  background: var(--accent-color);
  box-shadow: 0 0 0 6px color-mix(in srgb, var(--accent-color) 16%, white);
}

.stats-card__meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 18px;
  color: var(--text-secondary);
}

.stats-card__icon {
  display: inline-flex;
  width: 40px;
  height: 40px;
  align-items: center;
  justify-content: center;
  border-radius: 14px;
  background: color-mix(in srgb, var(--accent-color) 14%, white);
  color: var(--accent-color);
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 0.08em;
}

.stats-card__title {
  max-width: calc(100% - 52px);
  font-size: 16px;
  font-weight: 700;
}

.stats-card__value {
  display: flex;
  align-items: baseline;
  gap: 10px;
  margin-top: 18px;
  font-size: 36px;
  font-weight: 800;
  letter-spacing: -0.03em;
}

.stats-card__hint {
  max-width: 92%;
  margin: 14px 0 0;
  color: var(--text-muted);
  font-size: 13px;
  line-height: 1.65;
}
</style>