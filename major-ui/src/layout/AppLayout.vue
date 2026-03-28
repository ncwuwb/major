<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import AppHeader from '@/components/layout/AppHeader.vue'
import AppSidebar from '@/components/layout/AppSidebar.vue'
import { useAppStore } from '@/stores/app'

const appStore = useAppStore()
const route = useRoute()
const layoutClasses = computed(() => ({
  'app-layout--collapsed': appStore.sidebarCollapsed,
  'app-layout--fullscreen': Boolean(route.meta?.fullscreen),
}))
</script>

<template>
  <div class="app-layout" :class="layoutClasses">
    <AppSidebar v-if="!route.meta?.fullscreen" />
    <div class="app-layout__main">
      <AppHeader v-if="!route.meta?.fullscreen" />
      <main class="app-layout__content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<style scoped>
.app-layout {
  display: flex;
  min-height: 100vh;
}

.app-layout__main {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-direction: column;
  margin-left: 280px;
  padding: 18px;
  transition: margin-left 220ms ease;
}

.app-layout--collapsed .app-layout__main {
  margin-left: 84px;
}

.app-layout--fullscreen .app-layout__main {
  margin-left: 0;
  padding: 0;
}

.app-layout__content {
  min-height: 0;
  flex: 1;
}

@media (max-width: 960px) {
  .app-layout__main,
  .app-layout--collapsed .app-layout__main {
    margin-left: 0;
    padding: 12px;
  }
}
</style>
