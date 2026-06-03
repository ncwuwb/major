package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("warning_record")
public class WarningRecordEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long warningId;
    private Integer majorId;
    private String indicatorCode;
    private String indicatorName;
    private Integer statYear;
    private String compareType;
    private BigDecimal thresholdValue;
    private BigDecimal actualValue;
    private String status;
    private String message;
    private LocalDateTime triggeredAt;
    private LocalDateTime clearedAt;
    private String handleMsg;
    private String handleUser;
    private LocalDateTime handleTime;
}
