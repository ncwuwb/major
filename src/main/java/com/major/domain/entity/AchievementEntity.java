package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("achievement")
public class AchievementEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Integer achievementId;
    private Integer teacherId;
    private String name;
    private String type;
    private Integer statYear;
    private Integer unitCount;
}
