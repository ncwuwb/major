package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import java.math.BigDecimal;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("indicator_rule")
public class IndicatorRuleEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer ruleId;
    private String indicatorCode;
    private String indicatorName;
    private BigDecimal weight;
    private String compareType;
    private BigDecimal thresholdValue;
    private Integer enabled;
    private String remark;
}
