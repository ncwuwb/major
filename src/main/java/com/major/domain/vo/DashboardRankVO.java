package com.major.domain.vo;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class DashboardRankVO {

    private Integer majorId;
    private String majorName;
    private BigDecimal metricValue;
}
