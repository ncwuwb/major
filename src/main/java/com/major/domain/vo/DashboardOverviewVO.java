package com.major.domain.vo;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class DashboardOverviewVO {

    private Long majorCount;
    private Long studentCount;
    private Long teacherCount;
    private Long courseCount;
    private Long achievementCount;
    private BigDecimal phdRate;
    private BigDecimal admissionCompletionRate;
    private Long admissionPlanTotal;
    private Long admissionActualTotal;
    private BigDecimal fundingUtilizationRate;
    private BigDecimal fundingAllocatedTotal;
    private BigDecimal fundingSpentTotal;
    private Long competitionAwardCount;
    private BigDecimal employmentRate;
    private BigDecimal postgraduateRate;
    private BigDecimal averageSalary;
}
