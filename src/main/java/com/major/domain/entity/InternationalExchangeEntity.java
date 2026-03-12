package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("international_exchange")
public class InternationalExchangeEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer exchangeId;
    private Integer studentId;
    private String program;
    private Integer statYear;
    private String outcome;
}
