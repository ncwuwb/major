import AppLayout from '@/layout/AppLayout.vue'
import RouteGroup from '@/layout/RouteGroup.vue'
import { ROLE_CODES } from '@/constants/roles'

const BigScreenView = () => import('@/views/dashboard/BigScreenView.vue')
const LoginView = () => import('@/views/auth/LoginView.vue')
const ResourceCrudView = () => import('@/views/crud/ResourceCrudView.vue')
const WarningView = () => import('@/views/system/WarningView.vue')
const ImportToolView = () => import('@/views/tools/ImportToolView.vue')
const ForbiddenView = () => import('@/views/system/ForbiddenView.vue')

export const appRoutes = [
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: BigScreenView,
    meta: {
      title: '首页看板',
      icon: 'DataBoard',
      roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN],
    },
  },
  {
    path: '/bigscreen',
    name: 'BigScreenFullScreen',
    component: BigScreenView,
    meta: {
      title: '可视化大屏（全屏）',
      icon: 'DataBoard',
      roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN],
      fullscreen: true,
      hidden: true,
    },
  },
  {
    path: '/org',
    name: 'Organization',
    component: RouteGroup,
    meta: {
      title: '组织管理',
      icon: 'OfficeBuilding',
      roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN],
    },
    children: [
      { path: 'schools', name: 'SchoolManagement', component: ResourceCrudView, props: { resourceKey: 'schools' }, meta: { title: '学校管理', roles: [ROLE_CODES.SCHOOL_ADMIN] } },
      { path: 'campuses', name: 'CampusManagement', component: ResourceCrudView, props: { resourceKey: 'campuses' }, meta: { title: '校区管理', roles: [ROLE_CODES.SCHOOL_ADMIN] } },
      { path: 'departments', name: 'DepartmentManagement', component: ResourceCrudView, props: { resourceKey: 'departments' }, meta: { title: '学院管理', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN] } },
      { path: 'majors', name: 'MajorManagement', component: ResourceCrudView, props: { resourceKey: 'majors' }, meta: { title: '专业管理', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
      { path: 'users', name: 'UserManagement', component: ResourceCrudView, props: { resourceKey: 'users' }, meta: { title: '系统用户', roles: [ROLE_CODES.SCHOOL_ADMIN] } },
    ],
  },
  {
    path: '/master',
    name: 'MasterData',
    component: RouteGroup,
    meta: {
      title: '基础主数据',
      icon: 'CollectionTag',
      roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN],
    },
    children: [
      { path: 'teachers', name: 'TeacherManagement', component: ResourceCrudView, props: { resourceKey: 'teachers' }, meta: { title: '教师管理', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN] } },
      { path: 'students', name: 'StudentManagement', component: ResourceCrudView, props: { resourceKey: 'students' }, meta: { title: '学生管理', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
      { path: 'courses', name: 'CourseManagement', component: ResourceCrudView, props: { resourceKey: 'courses' }, meta: { title: '课程管理', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
      { path: 'experiment-bases', name: 'ExperimentBaseManagement', component: ResourceCrudView, props: { resourceKey: 'experimentBases' }, meta: { title: '实验基地', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN] } },
    ],
  },
  {
    path: '/annual',
    name: 'AnnualData',
    component: RouteGroup,
    meta: {
      title: '年度业务数据',
      icon: 'Calendar',
      roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN],
    },
    children: [
      { path: 'admissions', name: 'AdmissionData', component: ResourceCrudView, props: { resourceKey: 'admissions' }, meta: { title: '招生数据', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
      { path: 'fundings', name: 'FundingData', component: ResourceCrudView, props: { resourceKey: 'fundings' }, meta: { title: '经费数据', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
      { path: 'graduate-outcomes', name: 'GraduateOutcomeData', component: ResourceCrudView, props: { resourceKey: 'graduateOutcomes' }, meta: { title: '毕业去向', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
      { path: 'achievements', name: 'AchievementData', component: ResourceCrudView, props: { resourceKey: 'achievements' }, meta: { title: '成果数据', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN] } },
      { path: 'competitions', name: 'CompetitionData', component: ResourceCrudView, props: { resourceKey: 'competitions' }, meta: { title: '竞赛数据', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
      { path: 'international-exchanges', name: 'InternationalExchangeData', component: ResourceCrudView, props: { resourceKey: 'internationalExchanges' }, meta: { title: '国际交流', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
    ],
  },
  {
    path: '/warning',
    name: 'WarningRoot',
    component: RouteGroup,
    meta: {
      title: '预警中心',
      icon: 'Warning',
      roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN],
    },
    children: [
      { path: 'list', name: 'WarningList', component: WarningView, meta: { title: '预警管理', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN, ROLE_CODES.MAJOR_ADMIN] } },
    ],
  },
  {
    path: '/rules',
    name: 'RuleRoot',
    component: RouteGroup,
    meta: {
      title: '规则配置',
      icon: 'SetUp',
      roles: [ROLE_CODES.SCHOOL_ADMIN],
    },
    children: [
      { path: 'indicator', name: 'IndicatorRules', component: ResourceCrudView, props: { resourceKey: 'indicatorRules' }, meta: { title: '指标规则', roles: [ROLE_CODES.SCHOOL_ADMIN] } },
    ],
  },
  {
    path: '/tools',
    name: 'ToolRoot',
    component: RouteGroup,
    meta: {
      title: '数据工具',
      icon: 'Tools',
      roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN],
    },
    children: [
      { path: 'import', name: 'ImportTools', component: ImportToolView, meta: { title: '数据导入', roles: [ROLE_CODES.SCHOOL_ADMIN, ROLE_CODES.DEPT_ADMIN] } },
    ],
  },
]

export const baseRoutes = [
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
    meta: { public: true, title: '登录系统' },
  },
  {
    path: '/403',
    name: 'Forbidden',
    component: ForbiddenView,
    meta: { public: true, title: '无权限访问' },
  },
  {
    path: '/',
    component: AppLayout,
    redirect: '/dashboard',
    children: appRoutes,
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/dashboard',
  },
]
