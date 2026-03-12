package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("campus")
public class CampusEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer campusId;
    private Integer schoolId;
    private String name;
    private String province;
    private String city;
    private String district;
    private Integer isMain;
}
