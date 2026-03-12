import { defineStore } from 'pinia'

import { departmentApi, campusApi, majorApi, schoolApi } from '@/api/organization'
import { studentApi, teacherApi } from '@/api/masterData'

async function safeLoad(loader) {
  try {
    const response = await loader()
    return response?.records || []
  } catch (error) {
    return []
  }
}

export const useDictStore = defineStore('dicts', {
  state: () => ({
    schools: [],
    campuses: [],
    departments: [],
    majors: [],
    teachers: [],
    students: [],
    loaded: false,
  }),
  actions: {
    async loadAll(force = false) {
      if (this.loaded && !force) {
        return
      }
      const commonParams = { pageNum: 1, pageSize: 500 }
      const [schools, campuses, departments, majors, teachers, students] = await Promise.all([
        safeLoad(() => schoolApi.list(commonParams)),
        safeLoad(() => campusApi.list(commonParams)),
        safeLoad(() => departmentApi.list(commonParams)),
        safeLoad(() => majorApi.list(commonParams)),
        safeLoad(() => teacherApi.list(commonParams)),
        safeLoad(() => studentApi.list(commonParams)),
      ])

      this.schools = schools
      this.campuses = campuses
      this.departments = departments
      this.majors = majors
      this.teachers = teachers
      this.students = students
      this.loaded = true
    },
  },
})