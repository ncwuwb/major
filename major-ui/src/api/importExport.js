import request from '@/api/http'

export function importData(type, file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: `/import/${type}`,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  })
}

export async function downloadTemplate(type) {
  const response = await request({
    url: `/import/template/${type}`,
    method: 'get',
    responseType: 'blob',
  })
  downloadBlob(response, `${type}-template.xlsx`)
}

function downloadBlob(response, fallbackName) {
  const blob = new Blob([response.data])
  const link = document.createElement('a')
  const disposition = response.headers['content-disposition'] || ''
  const match = disposition.match(/filename\*=UTF-8''([^;]+)|filename=([^;]+)/i)
  const fileName = decodeURIComponent((match?.[1] || match?.[2] || fallbackName).replace(/"/g, '').trim())
  const url = URL.createObjectURL(blob)
  link.href = url
  link.download = fileName
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  URL.revokeObjectURL(url)
}

export async function exportMajorSummary(params) {
  const response = await request({
    url: '/export/major-summary',
    method: 'get',
    params,
    responseType: 'blob',
  })
  downloadBlob(response, 'major-summary.xlsx')
}

export async function exportWarningList(params) {
  const response = await request({
    url: '/export/warning-list',
    method: 'get',
    params,
    responseType: 'blob',
  })
  downloadBlob(response, 'warning-list.xlsx')
}

export async function exportAnnualIndicators(params) {
  const response = await request({
    url: '/export/annual-indicators',
    method: 'get',
    params,
    responseType: 'blob',
  })
  downloadBlob(response, 'annual-indicators.xlsx')
}

export async function exportData(type, params) {
  const response = await request({
    url: '/export/data',
    method: 'get',
    params: { type, ...params },
    responseType: 'blob',
  })
  downloadBlob(response, `${type}.xlsx`)
}