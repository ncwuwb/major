import dayjs from 'dayjs'

export function formatDateTime(value, pattern = 'YYYY-MM-DD HH:mm') {
  if (!value) {
    return '--'
  }
  return dayjs(value).isValid() ? dayjs(value).format(pattern) : value
}

export function formatPercent(value, fractionDigits = 2) {
  if (value === null || value === undefined || value === '') {
    return '--'
  }
  return `${Number(value).toFixed(fractionDigits)}%`
}

export function formatNumber(value, fractionDigits = 2) {
  if (value === null || value === undefined || value === '') {
    return '--'
  }
  return Number(value).toFixed(fractionDigits)
}

export function formatValue(value) {
  if (value === null || value === undefined || value === '') {
    return '--'
  }
  return value
}

export function findOptionLabel(options = [], value, labelKey = 'label', valueKey = 'value') {
  const target = options.find((item) => item?.[valueKey] === value)
  return target ? target[labelKey] : '--'
}