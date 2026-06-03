import request from '@/api/http'

export function fetchOverview(data) {
  return request({ url: '/dashboard/overview', method: 'post', data })
}

export function fetchTrend(data) {
  return request({ url: '/dashboard/trend', method: 'post', data })
}

export function fetchRank(data) {
  return request({ url: '/dashboard/rank', method: 'post', data })
}

export function fetchWarnings(data) {
  return request({ url: '/dashboard/warnings', method: 'post', data })
}

export function fetchScores(data) {
  return request({ url: '/dashboard/score', method: 'post', data })
}

export function recalculateWarnings() {
  return request({ url: '/dashboard/warnings/recalculate', method: 'post' })
}

export function fetchWarningMetrics(data) {
  return request({ url: '/dashboard/warnings/metrics', method: 'post', data })
}

export function handleWarning(warningId, data) {
  return request({ url: `/dashboard/warnings/${warningId}/handle`, method: 'post', data })
}
