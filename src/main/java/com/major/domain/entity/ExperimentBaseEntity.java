package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("experiment_base")
public class ExperimentBaseEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer baseId;
    private Integer majorId;
    private String name;
    private String type;
    private String location;
    private Integer capacity;
}
