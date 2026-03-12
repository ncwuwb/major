package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("department")
public class DepartmentEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer deptId;
    private Integer schoolId;
    private String code;
    private String name;
    private String type;
}
