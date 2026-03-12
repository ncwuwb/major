import request from '@/api/http'

export function login(data) {
  return request({
    url: '/auth/login',
    method: 'post',
    data,
  })
}

export function fetchCurrentUser() {
  return request({
    url: '/auth/me',
    method: 'get',
  })
}

export function changePassword(data) {
  return request({
    url: '/auth/change-password',
    method: 'post',
    data,
  })
}