<script setup>
defineProps({
  title: { type: String, required: true },
  subtitle: { type: String, default: '' },
  accent: { type: String, default: '#22c55e' },
})
</script>

<template>
  <section class="bigscreen-panel" :style="{ '--accent': accent }">
    <header class="bigscreen-panel__head">
      <div>
        <div class="bigscreen-panel__title-row">
          <h3>{{ title }}</h3>
          <span v-if="subtitle" class="bigscreen-panel__subtitle">{{ subtitle }}</span>
        </div>
        <slot name="kpi" />
      </div>
      <slot name="extra" />
    </header>
    <div class="bigscreen-panel__body">
      <slot />
    </div>
  </section>
</template>

<style scoped>
.bigscreen-panel {
  position: relative;
  overflow: hidden;
  border-radius: 18px;
  border: 1px solid rgba(120, 220, 255, 0.14);
  background:
    radial-gradient(circle at top left, color-mix(in srgb, var(--accent) 18%, transparent) 0%, transparent 48%),
    linear-gradient(180deg, rgba(8, 18, 28, 0.92), rgba(6, 14, 22, 0.86));
  box-shadow: 0 18px 40px rgba(0, 0, 0, 0.35);
  display: flex;
  flex-direction: column;
}

.bigscreen-panel::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    linear-gradient(120deg, rgba(255, 255, 255, 0.04), transparent 34%),
    repeating-linear-gradient(90deg, transparent 0 26px, rgba(255, 255, 255, 0.02) 26px 27px);
  pointer-events: none;
}

.bigscreen-panel__head,
.bigscreen-panel__body {
  position: relative;
  z-index: 1;
}

.bigscreen-panel__head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 16px 10px;
  border-bottom: 1px solid rgba(120, 220, 255, 0.12);
}

.bigscreen-panel__title-row {
  display: flex;
  align-items: baseline;
  gap: 10px;
}

.bigscreen-panel__head h3 {
  margin: 0;
  font-size: 15px;
  letter-spacing: 0.06em;
  color: rgba(240, 251, 255, 0.92);
}

.bigscreen-panel__subtitle {
  display: inline-flex;
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(34, 197, 94, 0.12);
  color: rgba(199, 255, 223, 0.92);
  font-size: 12px;
  font-weight: 700;
}

.bigscreen-panel__body {
  padding: 12px 14px 14px;
  min-height: 0;
  flex: 1;
  display: flex;
  flex-direction: column;
}
</style>

