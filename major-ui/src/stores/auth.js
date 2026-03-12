import { defineStore } from 'pinia'

import { fetchCurrentUser, login as loginApi } from '@/api/auth'
import { ROLE_CODES } from '@/constants/roles'
import { clearToken, getToken, setToken } from '@/utils/storage'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: getToken(),
    user: null,
    initialized: false,
  }),
  getters: {
    isLoggedIn: (state) => Boolean(state.token),
    roleCode: (state) => state.user?.roleCode || '',
    realName: (state) => state.user?.realName || state.user?.username || '未登录用户',
    scopeType: (state) => state.user?.scopeType || '',
    scopeId: (state) => state.user?.scopeId || null,
    isSchoolAdmin() {
      return this.roleCode === ROLE_CODES.SCHOOL_ADMIN
    },
    isDeptAdmin() {
      return this.roleCode === ROLE_CODES.DEPT_ADMIN
    },
    isMajorAdmin() {
      return this.roleCode === ROLE_CODES.MAJOR_ADMIN
    },
  },
  actions: {
    async login(payload) {
      const result = await loginApi(payload)
      this.token = result.token
      setToken(result.token)
      await this.initialize(true)
      return this.user
    },
    async initialize(force = false) {
      if (!this.token) {
        this.initialized = true
        return null
      }
      if (this.initialized && this.user && !force) {
        return this.user
      }
      try {
        this.user = await fetchCurrentUser()
        this.initialized = true
        return this.user
      } catch (error) {
        this.logout()
        throw error
      }
    },
    logout() {
      this.token = ''
      this.user = null
      this.initialized = false
      clearToken()
    },
  },
})