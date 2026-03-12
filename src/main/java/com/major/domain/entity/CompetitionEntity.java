package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("competition")
public class CompetitionEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer competitionId;
    private Integer studentId;
    private String name;
    private String level;
    private String award;
    private Integer statYear;
}
