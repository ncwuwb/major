import { createRestResource } from '@/api/resource'

export const teacherApi = createRestResource('/teachers')
export const studentApi = createRestResource('/students')
export const courseApi = createRestResource('/courses')
export const experimentBaseApi = createRestResource('/experiment-bases')