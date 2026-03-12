package com.major.domain.vo;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class DashboardOverviewVO {

    private Long majorCount;
    private Long studentCount;
    private Long teacherCount;
    private BigDecimal phdRate;
    private BigDecimal admissionCompletionRate;
    private BigDecimal fundingUtilizationRate;
    private Long competitionAwardCount;
    private BigDecimal employmentRate;
    private BigDecimal postgraduateRate;
}
