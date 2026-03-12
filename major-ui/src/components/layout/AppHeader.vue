<script setup>
import { computed } from 'vue'
import { useDateFormat, useNow } from '@vueuse/core'
import { ArrowRight, Expand, Fold, SwitchButton } from '@element-plus/icons-vue'
import { useRoute, useRouter } from 'vue-router'

import { ROLE_OPTIONS } from '@/constants/static-options'
import { useAppStore } from '@/stores/app'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const appStore = useAppStore()
const authStore = useAuthStore()

const now = useNow()
const nowText = useDateFormat(now, 'YYYY-MM-DD HH:mm:ss')
const breadcrumbs = computed(() => route.matched.filter((item) => item.meta?.title && item.path !== '/'))
const roleLabel = computed(() => ROLE_OPTIONS.find((item) => item.value === authStore.roleCode)?.label || authStore.roleCode || '--')
const collapseIcon = computed(() => (appStore.sidebarCollapsed ? Expand : Fold))

function handleLogout() {
  authStore.logout()
  router.replace('/login')
}
</script>

<template>
  <header class="app-header page-card">
    <div class="app-header__left">
      <el-button circle plain :icon="collapseIcon" @click="appStore.toggleSidebar" />
      <div>
        <h1>{{ route.meta?.title || '高校专业数据资源监测平台' }}</h1>
        <el-breadcrumb :separator-icon="ArrowRight">
          <el-breadcrumb-item v-for="item in breadcrumbs" :key="item.path">
            {{ item.meta?.title }}
          </el-breadcrumb-item>
        </el-breadcrumb>
      </div>
    </div>

    <div class="app-header__right">
      <div class="app-header__clock">
        <span class="muted">当前时间</span>
        <strong>{{ nowText }}</strong>
      </div>
      <el-tag v-if="appStore.demoMode" type="warning" effect="dark">答辩演示模式</el-tag>
      <el-dropdown>
        <div class="app-header__user">
          <div>
            <strong>{{ authStore.realName }}</strong>
            <span>{{ roleLabel }}</span>
          </div>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item :icon="SwitchButton" @click="handleLogout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </header>
</template>

<style scoped>
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  padding: 18px 22px;
}

.app-header__left,
.app-header__right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.app-header__left h1 {
  margin: 0 0 8px;
  font-size: 24px;
}

.app-header__clock {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.app-header__user {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.app-header__user strong,
.app-header__user span {
  display: block;
}

.app-header__user span {
  color: var(--text-muted);
  font-size: 12px;
}

@media (max-width: 900px) {
  .app-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .app-header__right {
    width: 100%;
    justify-content: space-between;
  }
}
</style>
