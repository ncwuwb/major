<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

import { ICON_MAP } from '@/constants/icon-map'
import { canAccessRoute } from '@/permission'
import { appRoutes } from '@/router/routes'
import { useAppStore } from '@/stores/app'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const appStore = useAppStore()
const authStore = useAuthStore()

function joinPath(base, path) {
  if (path.startsWith('/')) {
    return path
  }
  return `${base}/${path}`.replace(/\/+/g, '/').replace('//', '/')
}

function normalizeRoutes(routes, basePath = '') {
  return routes
    .filter((item) => canAccessRoute(authStore.roleCode, item))
    .filter((item) => !item.meta?.hidden)
    .map((item) => {
      const fullPath = joinPath(basePath || '', item.path)
      const children = item.children ? normalizeRoutes(item.children, fullPath) : []
      return {
        ...item,
        fullPath,
        children,
      }
    })
    .filter((item) => item.children.length > 0 || item.component)
}

const menuRoutes = computed(() => normalizeRoutes(appRoutes))

function handleNavigate(path) {
  router.push(path)
}
</script>

<template>
  <aside class="sidebar" :class="{ 'sidebar--collapsed': appStore.sidebarCollapsed }">
    <div class="sidebar__brand">
      <div class="sidebar__logo-wrap">
        <img class="sidebar__logo" src="/logo.png" alt="平台 Logo" />
      </div>
      <div v-if="!appStore.sidebarCollapsed" class="sidebar__brand-text">
        <strong>专业监测平台</strong>
        <span>Major Resource Dashboard</span>
      </div>
    </div>

    <el-scrollbar class="sidebar__menu-wrap">
      <el-menu
        :collapse="appStore.sidebarCollapsed"
        :default-active="route.path"
        class="sidebar__menu"
        background-color="transparent"
        text-color="var(--sidebar-text)"
        active-text-color="var(--sidebar-active-text)"
        unique-opened
      >
        <template v-for="item in menuRoutes" :key="item.fullPath">
          <el-sub-menu v-if="item.children.length" :index="item.fullPath">
            <template #title>
              <el-icon><component :is="ICON_MAP[item.meta?.icon]" /></el-icon>
              <span>{{ item.meta?.title }}</span>
            </template>
            <el-menu-item
              v-for="child in item.children"
              :key="child.fullPath"
              :index="child.fullPath"
              @click="handleNavigate(child.fullPath)"
            >
              {{ child.meta?.title }}
            </el-menu-item>
          </el-sub-menu>

          <el-menu-item v-else :index="item.fullPath" @click="handleNavigate(item.fullPath)">
            <el-icon><component :is="ICON_MAP[item.meta?.icon]" /></el-icon>
            <template #title>{{ item.meta?.title }}</template>
          </el-menu-item>
        </template>
      </el-menu>
    </el-scrollbar>
  </aside>
</template>

<style scoped>
.sidebar {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 40;
  display: flex;
  flex-direction: column;
  width: 280px;
  min-width: 280px;
  height: 100vh;
  padding: 22px 16px 16px;
  background:
    linear-gradient(180deg, rgba(252, 254, 255, 0.98), rgba(241, 247, 248, 0.98)),
    radial-gradient(circle at top left, rgba(15, 157, 138, 0.08), transparent 28%);
  border-right: 1px solid rgba(22, 52, 61, 0.08);
  box-shadow: 14px 0 34px rgba(21, 55, 62, 0.08);
  overflow: hidden;
}

.sidebar--collapsed {
  width: 84px;
  min-width: 84px;
}

.sidebar__brand {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 8px 18px;
}

.sidebar__logo-wrap {
  display: flex;
  width: 52px;
  height: 52px;
  align-items: center;
  justify-content: center;
  border-radius: 16px;
  background: linear-gradient(135deg, rgba(15, 157, 138, 0.12), rgba(15, 157, 138, 0.04));
  box-shadow: 0 10px 20px rgba(15, 157, 138, 0.14);
  flex-shrink: 0;
}

.sidebar__logo {
  display: block;
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 12px;
}

.sidebar__brand-text {
  display: flex;
  flex-direction: column;
}

.sidebar__brand-text strong {
  color: var(--text-primary);
  font-size: 18px;
}

.sidebar__brand-text span {
  color: var(--sidebar-text-muted);
  font-size: 12px;
}

.sidebar--collapsed .sidebar__brand {
  justify-content: center;
  padding-bottom: 16px;
}

.sidebar--collapsed .sidebar__logo-wrap {
  width: 44px;
  height: 44px;
}

.sidebar--collapsed .sidebar__logo {
  width: 34px;
  height: 34px;
}

.sidebar--collapsed .sidebar__brand-text {
  display: none;
}

.sidebar__menu-wrap {
  flex: 1;
  min-height: 0;
}

.sidebar__menu {
  border-right: none;
}

:deep(.el-scrollbar__wrap) {
  overflow-x: hidden;
}

:deep(.el-menu) {
  background: transparent;
  border-right: none;
}

:deep(.el-menu-item),
:deep(.el-sub-menu__title) {
  margin-bottom: 8px;
  border-radius: 16px;
  color: var(--sidebar-text);
}

:deep(.el-menu-item:hover),
:deep(.el-sub-menu__title:hover) {
  background: var(--sidebar-hover-bg) !important;
}

:deep(.el-sub-menu .el-menu-item) {
  min-width: 0;
  padding-left: 52px !important;
  color: var(--sidebar-text-muted);
}

:deep(.el-menu-item.is-active),
:deep(.el-sub-menu .el-menu-item.is-active) {
  background: var(--sidebar-active-bg) !important;
  color: var(--sidebar-active-text) !important;
  font-weight: 700;
}

:deep(.el-sub-menu.is-opened > .el-sub-menu__title) {
  color: var(--text-primary);
}

:deep(.el-menu-item.is-active .el-icon),
:deep(.el-sub-menu__title.is-active .el-icon) {
  color: var(--sidebar-active-text);
}

:deep(.el-menu-item),
:deep(.el-sub-menu__title),
:deep(.el-icon) {
  color: inherit;
}

@media (max-width: 960px) {
  .sidebar {
    display: none;
  }
}
</style>
