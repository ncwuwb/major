import { createRouter, createWebHistory } from 'vue-router'

import { canAccessRoute } from '@/permission'
import { baseRoutes } from '@/router/routes'
import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dicts'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: baseRoutes,
  scrollBehavior() {
    return { top: 0 }
  },
})

router.beforeEach(async (to) => {
  const authStore = useAuthStore()
  const dictStore = useDictStore()

  if (to.meta?.public) {
    if (to.path === '/login' && authStore.token) {
      try {
        await authStore.initialize()
        await dictStore.loadAll()
        return '/dashboard'
      } catch (error) {
        return true
      }
    }
    return true
  }

  if (!authStore.token) {
    return {
      path: '/login',
      query: { redirect: to.fullPath },
    }
  }

  try {
    await authStore.initialize()
    await dictStore.loadAll()
  } catch (error) {
    return {
      path: '/login',
      query: { redirect: to.fullPath },
    }
  }

  if (!canAccessRoute(authStore.roleCode, to)) {
    return '/403'
  }

  return true
})

router.afterEach((to) => {
  const title = to.meta?.title ? `${to.meta.title} - 高校专业数据资源监测平台` : '高校专业数据资源监测平台'
  document.title = title
})

export default router
