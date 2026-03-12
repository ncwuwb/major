import { hasRole } from '@/constants/roles'

export function canAccessRoute(roleCode, route) {
  return hasRole(roleCode, route.meta?.roles)
}

export function canAccessAction(roleCode, roles) {
  return hasRole(roleCode, roles)
}