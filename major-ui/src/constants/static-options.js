export const ROLE_OPTIONS = [
  { label: '学校管理员', value: 'SCHOOL_ADMIN' },
  { label: '学院管理员', value: 'DEPT_ADMIN' },
  { label: '专业管理员', value: 'MAJOR_ADMIN' },
]

export const SCOPE_TYPE_OPTIONS = [
  { label: '学校', value: 'SCHOOL' },
  { label: '学院', value: 'DEPT' },
  { label: '专业', value: 'MAJOR' },
]

export const ENABLE_OPTIONS = [
  { label: '启用', value: 1 },
  { label: '停用', value: 0 },
]

export const YES_NO_OPTIONS = [
  { label: '是', value: 1 },
  { label: '否', value: 0 },
]

export const COMPARE_TYPE_OPTIONS = [
  { label: '小于阈值预警', value: 'LT' },
  { label: '大于阈值预警', value: 'GT' },
]

export const METRIC_OPTIONS = [
  { label: '博士占比', value: 'PHD_RATE' },
  { label: '招生完成率', value: 'ADMISSION_COMPLETION_RATE' },
  { label: '经费使用率', value: 'FUNDING_UTILIZATION_RATE' },
  { label: '就业率', value: 'EMPLOYMENT_RATE' },
  { label: '升学率', value: 'POSTGRADUATE_RATE' },
]

export const TREND_METRIC_OPTIONS = [...METRIC_OPTIONS]

export const RESOURCE_IMPORT_OPTIONS = [
  { label: '教师数据', value: 'teachers' },
  { label: '学生数据', value: 'students' },
  { label: '课程数据', value: 'courses' },
  { label: '招生数据', value: 'admissions' },
  { label: '经费数据', value: 'fundings' },
  { label: '毕业去向', value: 'graduate-outcomes' },
]