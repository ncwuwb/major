import { createRestResource } from '@/api/resource'

export const admissionApi = createRestResource('/admissions')
export const fundingApi = createRestResource('/fundings')
export const graduateOutcomeApi = createRestResource('/graduate-outcomes')
export const achievementApi = createRestResource('/achievements')
export const competitionApi = createRestResource('/competitions')
export const internationalExchangeApi = createRestResource('/international-exchanges')