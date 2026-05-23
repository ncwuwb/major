import { exportData } from '@/api/importExport'
import { ROLE_CODES } from '@/constants/roles'

const ANNUAL_EXPORTABLE_KEYS = new Set([
  'admissions',
  'fundings',
  'graduateOutcomes',
  'achievements',
  'competitions',
  'internationalExchanges',
])

const TYPE_MAP = {
  admissions: 'admissions',
  fundings: 'fundings',
  graduateOutcomes: 'graduateOutcomes',
  achievements: 'achievements',
  competitions: 'competitions',
  internationalExchanges: 'internationalExchanges',
}

function buildAnnualParams(searchModel, authStore, dictStore, resourceKey) {
  const params = {}

  if (searchModel.year) {
    params.year = searchModel.year
  }

  // 成果数据按教师搜索，竞赛/国际交流按学生搜索，其余按专业搜索
  if (resourceKey === 'achievements') {
    if (searchModel.teacherId) {
      params.teacherId = searchModel.teacherId
    }
  } else if (resourceKey === 'competitions' || resourceKey === 'internationalExchanges') {
    if (searchModel.studentId) {
      params.studentId = searchModel.studentId
    }
  } else {
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

  const type = TYPE_MAP[resourceKey]

  return {
    label: '导出数据',
    roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN],
    async run(searchModel, { authStore, dictStore }) {
      const params = buildAnnualParams(searchModel, authStore, dictStore, resourceKey)
      await exportData(type, params)
    },
  }
}
