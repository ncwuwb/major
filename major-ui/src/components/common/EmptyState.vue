<script setup>
import { DocumentDelete } from '@element-plus/icons-vue'

defineProps({
  title: { type: String, default: '暂无数据' },
  description: { type: String, default: '当前筛选条件下没有可展示的内容。' },
})
</script>

<template>
  <div class="empty-state">
    <div class="empty-state__icon">
      <el-icon><DocumentDelete /></el-icon>
    </div>
    <h4>{{ title }}</h4>
    <p>{{ description }}</p>
  </div>
</template>

<style scoped>
.empty-state {
  display: flex;
  min-height: 180px;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  text-align: center;
}

.empty-state__icon {
  display: flex;
  width: 64px;
  height: 64px;
  align-items: center;
  justify-content: center;
  border-radius: 20px;
  background: rgba(15, 157, 138, 0.08);
  color: var(--brand-primary);
  font-size: 28px;
}

h4,
p {
  margin: 0;
}

p {
  color: var(--text-secondary);
}
</style>