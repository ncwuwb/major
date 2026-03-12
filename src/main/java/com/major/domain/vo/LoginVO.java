package com.major.domain.vo;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class LoginVO {

    private String token;
    private Long userId;
    private String username;
    private String realName;
    private String roleCode;
    private String scopeType;
    private Long scopeId;
}
