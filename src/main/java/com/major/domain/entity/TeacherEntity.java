package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("teacher")
public class TeacherEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer teacherId;
    private Integer deptId;
    private String teacherNo;
    private String name;
    private String title;
    private String degree;
    private Integer phdFlag;
    private String employmentType;
}
