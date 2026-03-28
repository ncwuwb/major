package com.major.domain.vo;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class WarningMetricVO {

    private String indicatorCode;
    private String indicatorName;
    private BigDecimal thresholdValue;
    private BigDecimal actualValue;
    private String compareType;
    private String status;
    private BigDecimal attainmentRate;
}

