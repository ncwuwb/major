export const ROLE_CODES = {
  SCHOOL_ADMIN: 'SCHOOL_ADMIN',
  DEPT_ADMIN: 'DEPT_ADMIN',
  MAJOR_ADMIN: 'MAJOR_ADMIN',
}

export function hasRole(roleCode, roles = []) {
  if (!roles || roles.length === 0) {
    return true
  }
  return roles.includes(roleCode)
}