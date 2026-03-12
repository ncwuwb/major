import axios from 'axios'
import { ElMessage } from 'element-plus'

import router from '@/router'
import { clearToken, getToken } from '@/utils/storage'

const service = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || '/api',
  timeout: 20000,
})

let unauthorizedHandling = false

function redirectToLogin() {
  if (unauthorizedHandling) {
    return
  }
  unauthorizedHandling = true
  clearToken()
  const currentPath = router.currentRoute.value?.fullPath || '/dashboard'
  const redirectPath = currentPath.startsWith('/login') ? '/dashboard' : currentPath
  router
    .replace({
      path: '/login',
      query: { redirect: redirectPath },
    })
    .finally(() => {
      unauthorizedHandling = false
    })
}

service.interceptors.request.use((config) => {
  const token = getToken()
  if (token) {
    config.headers = config.headers || {}
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

service.interceptors.response.use(
  (response) => {
    if (response.config.responseType === 'blob') {
      return response
    }

    const payload = response.data || {}
    if (payload.code === 200) {
      return payload.data
    }

    const message = payload.message || '请求失败'
    if (payload.code === 401) {
      redirectToLogin()
    }
    ElMessage.error(message)
    return Promise.reject(new Error(message))
  },
  (error) => {
    const status = error.response?.status
    const message = error.response?.data?.message || error.message || '网络请求异常'
    if (status === 401 || status === 403) {
      redirectToLogin()
    } else {
      ElMessage.error(message)
    }
    return Promise.reject(error)
  },
)

export default service