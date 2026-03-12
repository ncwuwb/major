package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.major.domain.entity.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("import_task")
public class ImportTaskEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long taskId;
    private String taskType;
    private String fileName;
    private String status;
    private Integer totalRows;
    private Integer successRows;
    private Integer failRows;
    private String errorMessage;
    private Long operatorUserId;
}
