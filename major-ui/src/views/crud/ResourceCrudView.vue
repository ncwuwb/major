<script setup>
import { computed } from 'vue'

import EmptyState from '@/components/common/EmptyState.vue'
import CrudPage from '@/components/crud/CrudPage.vue'
import { getResourceConfig } from '@/constants/resource-config'

const props = defineProps({
  resourceKey: {
    type: String,
    required: true,
  },
})

const config = computed(() => getResourceConfig(props.resourceKey))
</script>

<template>
  <CrudPage v-if="config" :config="config" />
  <div v-else class="page-shell">
    <div class="page-card" style="padding: 24px;">
      <EmptyState title="未找到资源配置" description="当前页面对应的资源配置不存在，请检查路由参数。" />
    </div>
  </div>
</template>