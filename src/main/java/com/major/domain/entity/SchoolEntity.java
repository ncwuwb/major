package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("school")
public class SchoolEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer schoolId;
    private String name;
    private String code;
    private String type;
    private String nature;
    private String level;
    private String website;
    private String contactName;
    private String contactPhone;
}
