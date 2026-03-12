import {
  achievementApi,
  admissionApi,
  competitionApi,
  fundingApi,
  graduateOutcomeApi,
  internationalExchangeApi,
} from '@/api/annualData'
import {
  courseApi,
  experimentBaseApi,
  studentApi,
  teacherApi,
} from '@/api/masterData'
import {
  campusApi,
  departmentApi,
  majorApi,
  schoolApi,
  userApi,
} from '@/api/organization'
import { indicatorRuleApi } from '@/api/systemConfig'
import {
  COMPARE_TYPE_OPTIONS,
  ENABLE_OPTIONS,
  ROLE_OPTIONS,
  SCOPE_TYPE_OPTIONS,
  YES_NO_OPTIONS,
} from '@/constants/static-options'
import { ROLE_CODES } from '@/constants/roles'

const DEGREE_OPTIONS = [
  { label: '学士', value: '学士' },
  { label: '硕士', value: '硕士' },
  { label: '博士', value: '博士' },
]

const TITLE_OPTIONS = [
  { label: '教授', value: '教授' },
  { label: '副教授', value: '副教授' },
  { label: '讲师', value: '讲师' },
  { label: '助教', value: '助教' },
]

const EMPLOYMENT_TYPE_OPTIONS = [
  { label: '专任教师', value: '专任教师' },
  { label: '双师型教师', value: '双师型教师' },
  { label: '外聘教师', value: '外聘教师' },
]

const GENDER_OPTIONS = [
  { label: '男', value: '男' },
  { label: '女', value: '女' },
]

const STUDENT_STATUS_OPTIONS = [
  { label: '在读', value: '在读' },
  { label: '休学', value: '休学' },
  { label: '毕业', value: '毕业' },
  { label: '退学', value: '退学' },
]

const COURSE_TYPE_OPTIONS = [
  { label: '必修', value: '必修' },
  { label: '选修', value: '选修' },
  { label: '实践', value: '实践' },
]

const SEMESTER_OPTIONS = [
  { label: '第一学期', value: '第一学期' },
  { label: '第二学期', value: '第二学期' },
  { label: '第三学期', value: '第三学期' },
  { label: '第四学期', value: '第四学期' },
  { label: '第五学期', value: '第五学期' },
  { label: '第六学期', value: '第六学期' },
  { label: '第七学期', value: '第七学期' },
  { label: '第八学期', value: '第八学期' },
]

const MAJOR_LEVEL_OPTIONS = [
  { label: '专科', value: '专科' },
  { label: '本科', value: '本科' },
  { label: '硕士', value: '硕士' },
]

const MAJOR_CATEGORY_OPTIONS = [
  { label: '工学', value: '工学' },
  { label: '理学', value: '理学' },
  { label: '管理学', value: '管理学' },
  { label: '文学', value: '文学' },
  { label: '教育学', value: '教育学' },
]

const SCHOOL_TYPE_OPTIONS = [
  { label: '普通高校', value: '普通高校' },
  { label: '职业院校', value: '职业院校' },
  { label: '应用型本科', value: '应用型本科' },
]

const SCHOOL_NATURE_OPTIONS = [
  { label: '公办', value: '公办' },
  { label: '民办', value: '民办' },
]

const SCHOOL_LEVEL_OPTIONS = [
  { label: '双一流', value: '双一流' },
  { label: '省属重点', value: '省属重点' },
  { label: '普通本科', value: '普通本科' },
]

const DEPARTMENT_TYPE_OPTIONS = [
  { label: '学院', value: '学院' },
  { label: '教学单位', value: '教学单位' },
  { label: '研究院', value: '研究院' },
]

const BASE_TYPE_OPTIONS = [
  { label: '校内实验室', value: '校内实验室' },
  { label: '校外实践基地', value: '校外实践基地' },
  { label: '联合实验中心', value: '联合实验中心' },
]

const ACHIEVEMENT_TYPE_OPTIONS = [
  { label: '论文', value: '论文' },
  { label: '专利', value: '专利' },
  { label: '项目', value: '项目' },
  { label: '教材', value: '教材' },
]

const COMPETITION_LEVEL_OPTIONS = [
  { label: '国家级', value: '国家级' },
  { label: '省级', value: '省级' },
  { label: '校级', value: '校级' },
]

const COMPETITION_AWARD_OPTIONS = [
  { label: '一等奖', value: '一等奖' },
  { label: '二等奖', value: '二等奖' },
  { label: '三等奖', value: '三等奖' },
  { label: '优秀奖', value: '优秀奖' },
]

export const STATUS_TAGS = {
  ACTIVE: 'danger',
  CLEARED: 'success',
  INACTIVE: 'info',
}

export const DICT_RESOURCE_KEYS = ['schools', 'campuses', 'departments', 'majors', 'teachers', 'students']

function buildOptions(items, valueKey, labelKey = 'name') {
  return (items || []).map((item) => ({
    label: item[labelKey],
    value: item[valueKey],
  }))
}

function getDictOptions(dictStore, key, model = {}) {
  switch (key) {
    case 'schools':
      return buildOptions(dictStore.schools, 'schoolId')
    case 'campuses':
      return buildOptions(dictStore.campuses, 'campusId')
    case 'departments':
      return buildOptions(dictStore.departments, 'deptId')
    case 'majors':
      if (model.deptId) {
        return buildOptions(dictStore.majors.filter((item) => item.deptId === model.deptId), 'majorId')
      }
      return buildOptions(dictStore.majors, 'majorId')
    case 'teachers':
      if (model.deptId) {
        return buildOptions(dictStore.teachers.filter((item) => item.deptId === model.deptId), 'teacherId')
      }
      return buildOptions(dictStore.teachers, 'teacherId')
    case 'students':
      if (model.majorId) {
        return buildOptions(dictStore.students.filter((item) => item.majorId === model.majorId), 'studentId')
      }
      return buildOptions(dictStore.students, 'studentId')
    case 'scopeTargets':
      if (model.scopeType === 'SCHOOL') {
        return buildOptions(dictStore.schools, 'schoolId')
      }
      if (model.scopeType === 'DEPT') {
        return buildOptions(dictStore.departments, 'deptId')
      }
      if (model.scopeType === 'MAJOR') {
        return buildOptions(dictStore.majors, 'majorId')
      }
      return []
    default:
      return []
  }
}

function inputField(prop, label, extra = {}) {
  return { prop, label, type: 'input', clearable: true, ...extra }
}

function numberField(prop, label, extra = {}) {
  return { prop, label, type: 'number', ...extra }
}

function selectField(prop, label, options, extra = {}) {
  return { prop, label, type: 'select', options, clearable: true, ...extra }
}

function dictField(prop, label, optionsKey, extra = {}) {
  return { prop, label, type: 'select', optionsKey, clearable: true, ...extra }
}

function textAreaField(prop, label, extra = {}) {
  return { prop, label, type: 'textarea', rows: 3, ...extra }
}

const schoolOnly = [ROLE_CODES.SCHOOL_ADMIN]
const schoolAndDept = [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN]
const allRoles = [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN]

export const RESOURCE_CONFIGS = {
  schools: {
    key: 'schools',
    title: '学校管理',
    idField: 'schoolId',
    routeRoles: schoolOnly,
    actionRoles: schoolOnly,
    searchFields: [inputField('keyword', '关键字', { placeholder: '学校名称 / 学校编码' })],
    columns: [
      { prop: 'schoolId', label: 'ID', width: 80 },
      { prop: 'name', label: '学校名称', minWidth: 180 },
      { prop: 'code', label: '学校编码', minWidth: 140 },
      { prop: 'type', label: '学校类型', minWidth: 120 },
      { prop: 'nature', label: '办学性质', minWidth: 120 },
      { prop: 'level', label: '学校层次', minWidth: 120 },
      { prop: 'contactName', label: '联系人', minWidth: 110 },
      { prop: 'contactPhone', label: '联系电话', minWidth: 140 },
      { prop: 'createdAt', label: '创建时间', minWidth: 160, format: 'datetime' },
    ],
    formFields: [
      inputField('name', '学校名称', { required: true }),
      inputField('code', '学校编码', { required: true }),
      selectField('type', '学校类型', SCHOOL_TYPE_OPTIONS, { required: true }),
      selectField('nature', '办学性质', SCHOOL_NATURE_OPTIONS, { required: true }),
      selectField('level', '学校层次', SCHOOL_LEVEL_OPTIONS, { required: true }),
      inputField('website', '学校官网'),
      inputField('contactName', '联系人'),
      inputField('contactPhone', '联系电话'),
    ],
    service: schoolApi,
  },
  campuses: {
    key: 'campuses',
    title: '校区管理',
    idField: 'campusId',
    routeRoles: schoolOnly,
    actionRoles: schoolOnly,
    searchFields: [inputField('keyword', '关键字', { placeholder: '校区名称' })],
    columns: [
      { prop: 'campusId', label: 'ID', width: 80 },
      { prop: 'schoolId', label: '所属学校', minWidth: 180, lookupKey: 'schools' },
      { prop: 'name', label: '校区名称', minWidth: 160 },
      { prop: 'province', label: '省份', minWidth: 100 },
      { prop: 'city', label: '城市', minWidth: 100 },
      { prop: 'district', label: '区县', minWidth: 100 },
      { prop: 'isMain', label: '主校区', minWidth: 100, options: YES_NO_OPTIONS },
    ],
    formFields: [
      dictField('schoolId', '所属学校', 'schools', { required: true }),
      inputField('name', '校区名称', { required: true }),
      inputField('province', '省份', { required: true }),
      inputField('city', '城市', { required: true }),
      inputField('district', '区县'),
      selectField('isMain', '是否主校区', YES_NO_OPTIONS, { required: true, defaultValue: 1 }),
    ],
    service: campusApi,
  },
  departments: {
    key: 'departments',
    title: '学院管理',
    idField: 'deptId',
    routeRoles: schoolAndDept,
    actionRoles: schoolOnly,
    searchFields: [inputField('keyword', '关键字', { placeholder: '学院名称 / 编码' })],
    columns: [
      { prop: 'deptId', label: 'ID', width: 80 },
      { prop: 'schoolId', label: '所属学校', minWidth: 180, lookupKey: 'schools' },
      { prop: 'code', label: '学院编码', minWidth: 120 },
      { prop: 'name', label: '学院名称', minWidth: 180 },
      { prop: 'type', label: '学院类型', minWidth: 140 },
      { prop: 'createdAt', label: '创建时间', minWidth: 160, format: 'datetime' },
    ],
    formFields: [
      dictField('schoolId', '所属学校', 'schools', { required: true }),
      inputField('code', '学院编码', { required: true }),
      inputField('name', '学院名称', { required: true }),
      selectField('type', '学院类型', DEPARTMENT_TYPE_OPTIONS, { required: true }),
    ],
    service: departmentApi,
  },
  majors: {
    key: 'majors',
    title: '专业管理',
    idField: 'majorId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '专业名称 / 编码' }),
      dictField('deptId', '学院', 'departments'),
    ],
    columns: [
      { prop: 'majorId', label: 'ID', width: 80 },
      { prop: 'deptId', label: '所属学院', minWidth: 180, lookupKey: 'departments' },
      { prop: 'name', label: '专业名称', minWidth: 180 },
      { prop: 'code', label: '专业编码', minWidth: 120 },
      { prop: 'level', label: '培养层次', minWidth: 100 },
      { prop: 'category', label: '学科门类', minWidth: 120 },
      { prop: 'durationYears', label: '学制(年)', minWidth: 100 },
    ],
    formFields: [
      dictField('deptId', '所属学院', 'departments', { required: true }),
      inputField('name', '专业名称', { required: true }),
      inputField('code', '专业编码', { required: true }),
      selectField('level', '培养层次', MAJOR_LEVEL_OPTIONS, { required: true }),
      selectField('category', '学科门类', MAJOR_CATEGORY_OPTIONS, { required: true }),
      numberField('durationYears', '学制年限', { required: true, min: 1, max: 8, precision: 0 }),
    ],
    service: majorApi,
  },
  users: {
    key: 'users',
    title: '系统用户',
    idField: 'userId',
    routeRoles: schoolOnly,
    actionRoles: schoolOnly,
    searchFields: [inputField('keyword', '关键字', { placeholder: '用户名 / 姓名' })],
    columns: [
      { prop: 'userId', label: 'ID', width: 90 },
      { prop: 'username', label: '用户名', minWidth: 130 },
      { prop: 'realName', label: '姓名', minWidth: 120 },
      { prop: 'roleCode', label: '角色', minWidth: 120, options: ROLE_OPTIONS },
      { prop: 'scopeType', label: '数据范围', minWidth: 120, options: SCOPE_TYPE_OPTIONS },
      { prop: 'scopeId', label: '范围对象', minWidth: 180, dynamicLookup: true },
      { prop: 'status', label: '状态', minWidth: 100, options: ENABLE_OPTIONS },
      { prop: 'lastLoginAt', label: '最近登录', minWidth: 160, format: 'datetime' },
    ],
    formFields: [
      inputField('username', '用户名', { required: true }),
      inputField('password', '登录密码', { requiredOnCreate: true, password: true, placeholder: '编辑时可留空保留原密码' }),
      inputField('realName', '姓名', { required: true }),
      inputField('phone', '手机号'),
      inputField('email', '邮箱'),
      selectField('roleCode', '角色', ROLE_OPTIONS, { required: true }),
      selectField('scopeType', '数据范围类型', SCOPE_TYPE_OPTIONS, { required: true }),
      dictField('scopeId', '范围对象', 'scopeTargets', { required: true }),
      selectField('status', '账号状态', ENABLE_OPTIONS, { required: true, defaultValue: 1 }),
    ],
    beforeSubmit(payload, context) {
      if (context.isEdit && !payload.password) {
        delete payload.password
      }
      if (payload.scopeId !== null && payload.scopeId !== undefined && payload.scopeId !== '') {
        payload.scopeId = Number(payload.scopeId)
      }
      return payload
    },
    service: userApi,
  },
  teachers: {
    key: 'teachers',
    title: '教师管理',
    idField: 'teacherId',
    routeRoles: schoolAndDept,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '教师姓名 / 工号' }),
      dictField('deptId', '学院', 'departments'),
    ],
    columns: [
      { prop: 'teacherId', label: 'ID', width: 80 },
      { prop: 'teacherNo', label: '工号', minWidth: 120 },
      { prop: 'name', label: '姓名', minWidth: 120 },
      { prop: 'deptId', label: '所属学院', minWidth: 170, lookupKey: 'departments' },
      { prop: 'title', label: '职称', minWidth: 100 },
      { prop: 'degree', label: '学历学位', minWidth: 100 },
      { prop: 'phdFlag', label: '博士标记', minWidth: 100, options: YES_NO_OPTIONS },
      { prop: 'employmentType', label: '聘用类型', minWidth: 140 },
    ],
    formFields: [
      dictField('deptId', '所属学院', 'departments', { required: true }),
      inputField('teacherNo', '教师工号', { required: true }),
      inputField('name', '教师姓名', { required: true }),
      selectField('title', '教师职称', TITLE_OPTIONS, { required: true }),
      selectField('degree', '学历学位', DEGREE_OPTIONS, { required: true }),
      selectField('phdFlag', '是否博士', YES_NO_OPTIONS, { required: true, defaultValue: 0 }),
      selectField('employmentType', '聘用类型', EMPLOYMENT_TYPE_OPTIONS, { required: true }),
    ],
    service: teacherApi,
  },
  students: {
    key: 'students',
    title: '学生管理',
    idField: 'studentId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '学生姓名 / 学号' }),
      dictField('majorId', '专业', 'majors'),
    ],
    columns: [
      { prop: 'studentId', label: 'ID', width: 80 },
      { prop: 'studentNo', label: '学号', minWidth: 140 },
      { prop: 'name', label: '姓名', minWidth: 120 },
      { prop: 'majorId', label: '所属专业', minWidth: 180, lookupKey: 'majors' },
      { prop: 'gender', label: '性别', minWidth: 80 },
      { prop: 'enrollmentYear', label: '入学年份', minWidth: 100 },
      { prop: 'status', label: '学籍状态', minWidth: 100 },
    ],
    formFields: [
      dictField('majorId', '所属专业', 'majors', { required: true }),
      inputField('studentNo', '学生学号', { required: true }),
      inputField('name', '学生姓名', { required: true }),
      selectField('gender', '性别', GENDER_OPTIONS, { required: true }),
      numberField('enrollmentYear', '入学年份', { required: true, min: 2000, max: 2100, precision: 0 }),
      selectField('status', '学籍状态', STUDENT_STATUS_OPTIONS, { required: true, defaultValue: '在读' }),
    ],
    service: studentApi,
  },
  courses: {
    key: 'courses',
    title: '课程管理',
    idField: 'courseId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '课程名称 / 课程代码' }),
      dictField('majorId', '专业', 'majors'),
    ],
    columns: [
      { prop: 'courseId', label: 'ID', width: 80 },
      { prop: 'courseCode', label: '课程代码', minWidth: 120 },
      { prop: 'name', label: '课程名称', minWidth: 160 },
      { prop: 'majorId', label: '所属专业', minWidth: 180, lookupKey: 'majors' },
      { prop: 'type', label: '课程类型', minWidth: 100 },
      { prop: 'credits', label: '学分', minWidth: 100 },
      { prop: 'semester', label: '开课学期', minWidth: 120 },
    ],
    formFields: [
      dictField('majorId', '所属专业', 'majors', { required: true }),
      inputField('courseCode', '课程代码', { required: true }),
      inputField('name', '课程名称', { required: true }),
      selectField('type', '课程类型', COURSE_TYPE_OPTIONS, { required: true }),
      numberField('credits', '课程学分', { required: true, min: 0, max: 20, precision: 1 }),
      selectField('semester', '开课学期', SEMESTER_OPTIONS, { required: true }),
    ],
    service: courseApi,
  },
  experimentBases: {
    key: 'experimentBases',
    title: '实验基地',
    idField: 'baseId',
    routeRoles: schoolAndDept,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '基地名称' }),
      dictField('majorId', '专业', 'majors'),
    ],
    columns: [
      { prop: 'baseId', label: 'ID', width: 80 },
      { prop: 'name', label: '基地名称', minWidth: 160 },
      { prop: 'majorId', label: '所属专业', minWidth: 180, lookupKey: 'majors' },
      { prop: 'type', label: '基地类型', minWidth: 140 },
      { prop: 'location', label: '所在地点', minWidth: 180 },
      { prop: 'capacity', label: '容量', minWidth: 100 },
    ],
    formFields: [
      dictField('majorId', '所属专业', 'majors', { required: true }),
      inputField('name', '基地名称', { required: true }),
      selectField('type', '基地类型', BASE_TYPE_OPTIONS, { required: true }),
      inputField('location', '地理位置', { required: true }),
      numberField('capacity', '可容纳人数', { required: true, min: 0, precision: 0 }),
    ],
    service: experimentBaseApi,
  },
  admissions: {
    key: 'admissions',
    title: '招生数据',
    idField: 'admissionId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      dictField('majorId', '专业', 'majors'),
      numberField('year', '年份', { precision: 0 }),
    ],
    columns: [
      { prop: 'admissionId', label: 'ID', width: 80 },
      { prop: 'majorId', label: '专业', minWidth: 180, lookupKey: 'majors' },
      { prop: 'statYear', label: '年份', minWidth: 100 },
      { prop: 'planCount', label: '招生计划', minWidth: 100 },
      { prop: 'actualCount', label: '实际招生', minWidth: 100 },
      { prop: 'minScore', label: '最低分', minWidth: 100 },
      { prop: 'maxScore', label: '最高分', minWidth: 100 },
    ],
    formFields: [
      dictField('majorId', '专业', 'majors', { required: true }),
      numberField('statYear', '统计年份', { required: true, precision: 0 }),
      numberField('planCount', '招生计划数', { required: true, precision: 0 }),
      numberField('actualCount', '实际招生数', { required: true, precision: 0 }),
      numberField('minScore', '最低分', { precision: 1 }),
      numberField('maxScore', '最高分', { precision: 1 }),
    ],
    service: admissionApi,
  },
  fundings: {
    key: 'fundings',
    title: '经费数据',
    idField: 'fundingId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      dictField('majorId', '专业', 'majors'),
      numberField('year', '年份', { precision: 0 }),
    ],
    columns: [
      { prop: 'fundingId', label: 'ID', width: 80 },
      { prop: 'majorId', label: '专业', minWidth: 180, lookupKey: 'majors' },
      { prop: 'statYear', label: '年份', minWidth: 100 },
      { prop: 'allocated', label: '预算经费', minWidth: 120 },
      { prop: 'spent', label: '已使用经费', minWidth: 120 },
      { prop: 'utilizationRate', label: '使用率', minWidth: 100, format: 'percent' },
    ],
    formFields: [
      dictField('majorId', '专业', 'majors', { required: true }),
      numberField('statYear', '统计年份', { required: true, precision: 0 }),
      numberField('allocated', '预算经费', { required: true, precision: 2, min: 0 }),
      numberField('spent', '已使用经费', { required: true, precision: 2, min: 0 }),
      numberField('utilizationRate', '经费使用率', { precision: 2, min: 0, max: 100, helperText: '如不填写，将按已使用经费 / 预算经费自动计算。' }),
    ],
    beforeSubmit(payload) {
      if ((payload.utilizationRate === null || payload.utilizationRate === undefined || payload.utilizationRate === '') && Number(payload.allocated || 0) > 0) {
        const rate = (Number(payload.spent || 0) / Number(payload.allocated || 0)) * 100
        payload.utilizationRate = Number.isFinite(rate) ? Number(rate.toFixed(2)) : 0
      }
      return payload
    },
    service: fundingApi,
  },
  graduateOutcomes: {
    key: 'graduateOutcomes',
    title: '毕业去向',
    idField: 'outcomeId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      dictField('majorId', '专业', 'majors'),
      numberField('year', '年份', { precision: 0 }),
    ],
    columns: [
      { prop: 'outcomeId', label: 'ID', width: 80 },
      { prop: 'majorId', label: '专业', minWidth: 180, lookupKey: 'majors' },
      { prop: 'statYear', label: '年份', minWidth: 100 },
      { prop: 'graduateCount', label: '毕业人数', minWidth: 100 },
      { prop: 'employmentRate', label: '就业率', minWidth: 100, format: 'percent' },
      { prop: 'postgraduateRate', label: '升学率', minWidth: 100, format: 'percent' },
      { prop: 'averageSalary', label: '平均薪资', minWidth: 120 },
    ],
    formFields: [
      dictField('majorId', '专业', 'majors', { required: true }),
      numberField('statYear', '统计年份', { required: true, precision: 0 }),
      numberField('graduateCount', '毕业人数', { required: true, precision: 0, min: 0 }),
      numberField('employmentRate', '就业率', { required: true, precision: 2, min: 0, max: 100 }),
      numberField('postgraduateRate', '升学率', { required: true, precision: 2, min: 0, max: 100 }),
      numberField('averageSalary', '平均薪资', { precision: 2, min: 0 }),
    ],
    service: graduateOutcomeApi,
  },
  achievements: {
    key: 'achievements',
    title: '成果数据',
    idField: 'achievementId',
    routeRoles: schoolAndDept,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '成果名称' }),
      dictField('teacherId', '教师', 'teachers'),
      numberField('year', '年份', { precision: 0 }),
    ],
    columns: [
      { prop: 'achievementId', label: 'ID', width: 80 },
      { prop: 'teacherId', label: '教师', minWidth: 140, lookupKey: 'teachers' },
      { prop: 'name', label: '成果名称', minWidth: 180 },
      { prop: 'type', label: '成果类型', minWidth: 120 },
      { prop: 'statYear', label: '年份', minWidth: 90 },
      { prop: 'unitCount', label: '成果数量', minWidth: 100 },
    ],
    formFields: [
      dictField('teacherId', '教师', 'teachers', { required: true }),
      inputField('name', '成果名称', { required: true }),
      selectField('type', '成果类型', ACHIEVEMENT_TYPE_OPTIONS, { required: true }),
      numberField('statYear', '统计年份', { required: true, precision: 0 }),
      numberField('unitCount', '成果数量', { required: true, precision: 0, min: 0 }),
    ],
    service: achievementApi,
  },
  competitions: {
    key: 'competitions',
    title: '竞赛数据',
    idField: 'competitionId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '竞赛名称' }),
      dictField('studentId', '学生', 'students'),
      numberField('year', '年份', { precision: 0 }),
    ],
    columns: [
      { prop: 'competitionId', label: 'ID', width: 80 },
      { prop: 'studentId', label: '学生', minWidth: 140, lookupKey: 'students' },
      { prop: 'name', label: '竞赛名称', minWidth: 180 },
      { prop: 'level', label: '级别', minWidth: 120 },
      { prop: 'award', label: '获奖等级', minWidth: 120 },
      { prop: 'statYear', label: '年份', minWidth: 90 },
    ],
    formFields: [
      dictField('studentId', '学生', 'students', { required: true }),
      inputField('name', '竞赛名称', { required: true }),
      selectField('level', '竞赛级别', COMPETITION_LEVEL_OPTIONS, { required: true }),
      selectField('award', '获奖等级', COMPETITION_AWARD_OPTIONS, { required: true }),
      numberField('statYear', '统计年份', { required: true, precision: 0 }),
    ],
    service: competitionApi,
  },
  internationalExchanges: {
    key: 'internationalExchanges',
    title: '国际交流',
    idField: 'exchangeId',
    routeRoles: allRoles,
    actionRoles: schoolAndDept,
    searchFields: [
      inputField('keyword', '关键字', { placeholder: '项目名称' }),
      dictField('studentId', '学生', 'students'),
      numberField('year', '年份', { precision: 0 }),
    ],
    columns: [
      { prop: 'exchangeId', label: 'ID', width: 80 },
      { prop: 'studentId', label: '学生', minWidth: 140, lookupKey: 'students' },
      { prop: 'program', label: '项目名称', minWidth: 180 },
      { prop: 'statYear', label: '年份', minWidth: 90 },
      { prop: 'outcome', label: '项目成果', minWidth: 180 },
    ],
    formFields: [
      dictField('studentId', '学生', 'students', { required: true }),
      inputField('program', '项目名称', { required: true }),
      numberField('statYear', '统计年份', { required: true, precision: 0 }),
      textAreaField('outcome', '项目成果'),
    ],
    service: internationalExchangeApi,
  },
  indicatorRules: {
    key: 'indicatorRules',
    title: '指标规则',
    idField: 'ruleId',
    routeRoles: schoolOnly,
    actionRoles: schoolOnly,
    searchFields: [inputField('keyword', '关键字', { placeholder: '指标名称 / 编码' })],
    columns: [
      { prop: 'ruleId', label: 'ID', width: 80 },
      { prop: 'indicatorCode', label: '指标编码', minWidth: 180 },
      { prop: 'indicatorName', label: '指标名称', minWidth: 160 },
      { prop: 'weight', label: '评分权重', minWidth: 100 },
      { prop: 'compareType', label: '比较方式', minWidth: 140, options: COMPARE_TYPE_OPTIONS },
      { prop: 'thresholdValue', label: '预警阈值', minWidth: 100 },
      { prop: 'enabled', label: '启用状态', minWidth: 100, options: ENABLE_OPTIONS },
    ],
    formFields: [
      inputField('indicatorCode', '指标编码', { required: true }),
      inputField('indicatorName', '指标名称', { required: true }),
      numberField('weight', '评分权重', { precision: 2, min: 0 }),
      selectField('compareType', '比较方式', COMPARE_TYPE_OPTIONS, { required: true }),
      numberField('thresholdValue', '预警阈值', { required: true, precision: 2 }),
      selectField('enabled', '启用状态', ENABLE_OPTIONS, { required: true, defaultValue: 1 }),
      textAreaField('remark', '备注说明'),
    ],
    service: indicatorRuleApi,
  },
}

export function getResourceConfig(resourceKey) {
  return RESOURCE_CONFIGS[resourceKey]
}

export function resolveFieldOptions(field, dictStore, model) {
  if (typeof field.options === 'function') {
    return field.options(dictStore, model)
  }
  if (field.options) {
    return field.options
  }
  if (field.optionsKey) {
    return getDictOptions(dictStore, field.optionsKey, model)
  }
  return []
}

export function resolveDynamicLookup(value, row, dictStore) {
  if (row.scopeType === 'SCHOOL') {
    return getDictOptions(dictStore, 'schools', row).find((item) => item.value === value)?.label || '--'
  }
  if (row.scopeType === 'DEPT') {
    return getDictOptions(dictStore, 'departments', row).find((item) => item.value === value)?.label || '--'
  }
  if (row.scopeType === 'MAJOR') {
    return getDictOptions(dictStore, 'majors', row).find((item) => item.value === value)?.label || '--'
  }
  return '--'
}