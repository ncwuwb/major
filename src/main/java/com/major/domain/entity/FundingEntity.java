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
@TableName("funding")
public class FundingEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer fundingId;
    private Integer majorId;
    private Integer statYear;
    private BigDecimal allocated;
    private BigDecimal spent;
    private BigDecimal utilizationRate;
}
