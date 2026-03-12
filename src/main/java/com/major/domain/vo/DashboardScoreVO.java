package com.major.domain.vo;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class DashboardScoreVO {

    private Integer majorId;
    private String majorName;
    private BigDecimal phdRate;
    private BigDecimal admissionCompletionRate;
    private BigDecimal fundingUtilizationRate;
    private BigDecimal employmentRate;
    private BigDecimal postgraduateRate;
    private BigDecimal totalScore;
}
