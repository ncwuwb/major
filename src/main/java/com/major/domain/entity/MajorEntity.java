package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("major")
public class MajorEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer majorId;
    private Integer deptId;
    private String name;
    private String code;
    private String level;
    private String category;
    private Integer durationYears;
}
