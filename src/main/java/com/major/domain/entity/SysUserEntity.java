package com.major.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.major.domain.entity.base.BaseEntity;
import java.time.LocalDateTime;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class SysUserEntity extends BaseEntity {

    @TableId(type = IdType.AUTO)
    private Long userId;
    private String username;
    /** 仅允许请求体写入（新增/修改密码），序列化响应时不输出，避免泄露 */
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;
    private String realName;
    private String phone;
    private String email;
    private String roleCode;
    private String scopeType;
    private Long scopeId;
    private Integer status;
    private LocalDateTime lastLoginAt;
}
