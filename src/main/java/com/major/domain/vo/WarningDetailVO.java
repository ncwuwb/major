package com.major.domain.vo;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.Data;

@Data
public class WarningDetailVO {

    private Long warningId;
    private Integer majorId;
    private String majorName;
    private String indicatorCode;
    private String indicatorName;
    private Integer statYear;
    private BigDecimal thresholdValue;
    private BigDecimal actualValue;
    private String status;
    private String message;
    private LocalDateTime triggeredAt;
}
