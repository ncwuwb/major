package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("student")
public class StudentEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer studentId;
    private Integer majorId;
    private String studentNo;
    private String name;
    private String gender;
    private Integer enrollmentYear;
    private String status;
}
