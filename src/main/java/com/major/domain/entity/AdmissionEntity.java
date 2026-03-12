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
@TableName("admission")
public class AdmissionEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer admissionId;
    private Integer majorId;
    private Integer statYear;
    private Integer planCount;
    private Integer actualCount;
    private BigDecimal minScore;
    private BigDecimal maxScore;
}
