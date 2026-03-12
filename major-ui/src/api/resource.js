import request from '@/api/http'

export function createRestResource(endpoint) {
  return {
    list(params) {
      return request({
        url: endpoint,
        method: 'get',
        params,
      })
    },
    detail(id) {
      return request({
        url: `${endpoint}/${id}`,
        method: 'get',
      })
    },
    create(data) {
      return request({
        url: endpoint,
        method: 'post',
        data,
      })
    },
    update(id, data) {
      return request({
        url: `${endpoint}/${id}`,
        method: 'put',
        data,
      })
    },
    remove(id) {
      return request({
        url: `${endpoint}/${id}`,
        method: 'delete',
      })
    },
  }
}