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
@TableName("graduate_outcome")
public class GraduateOutcomeEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer outcomeId;
    private Integer majorId;
    private Integer statYear;
    private Integer graduateCount;
    private BigDecimal employmentRate;
    private BigDecimal postgraduateRate;
    private BigDecimal averageSalary;
}
