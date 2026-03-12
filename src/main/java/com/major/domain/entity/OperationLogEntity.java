package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@TableName("operation_log")
public class OperationLogEntity implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long logId;
    private Long userId;
    private String username;
    private String module;
    private String operation;
    private String requestMethod;
    private String requestUri;
    private String requestBody;
    private Integer success;
    private String errorMessage;
    private LocalDateTime createdAt;
    private Integer deleted;
}
