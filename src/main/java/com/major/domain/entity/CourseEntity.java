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
@TableName("course")
public class CourseEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer courseId;
    private Integer majorId;
    private String courseCode;
    private String name;
    private String type;
    private BigDecimal credits;
    private String semester;
}
