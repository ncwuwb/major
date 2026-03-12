import { createRestResource } from '@/api/resource'

export const schoolApi = createRestResource('/schools')
export const campusApi = createRestResource('/campuses')
export const departmentApi = createRestResource('/departments')
export const majorApi = createRestResource('/majors')
export const userApi = createRestResource('/users')