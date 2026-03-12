package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("report_template")
public class ReportTemplateEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer templateId;
    private String name;
    private String description;
    private String format;
}
