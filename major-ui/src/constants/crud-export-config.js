import { exportAnnualIndicators } from '@/api/importExport'
import { ROLE_CODES } from '@/constants/roles'

const ANNUAL_EXPORTABLE_KEYS = new Set([
  'admissions',
  'fundings',
  'graduateOutcomes',
  'achievements',
  'competitions',
  'internationalExchanges',
])

function buildAnnualParams(searchModel, authStore, dictStore) {
  const params = {}

  if (searchModel.year) {
    params.year = searchModel.year
  }

  if (searchModel.majorId) {
    params.majorId = searchModel.majorId
    const major = dictStore.majors.find((item) => Number(item.majorId) === Number(searchModel.majorId))
    if (major?.deptId) {
      params.deptId = major.deptId
    }
  } else if (authStore.isMajorAdmin) {
    params.majorId = Number(authStore.scopeId)
    const major = dictStore.majors.find((item) => Number(item.majorId) === Number(authStore.scopeId))
    if (major?.deptId) {
      params.deptId = major.deptId
    }
  }

  if (authStore.isDeptAdmin) {
    params.deptId = Number(authStore.scopeId)
  }

  if (searchModel.deptId) {
    params.deptId = searchModel.deptId
  }

  return params
}

export function getCrudExportConfig(resourceKey) {
  if (!ANNUAL_EXPORTABLE_KEYS.has(resourceKey)) {
    return null
  }

  return {
    label: '导出年度指标',
    roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN],
    async run(searchModel, { authStore, dictStore }) {
      const params = buildAnnualParams(searchModel, authStore, dictStore)
      await exportAnnualIndicators(params)
    },
  }
}
