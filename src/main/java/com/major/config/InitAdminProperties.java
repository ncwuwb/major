package com.major.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "major.init-admin")
public class InitAdminProperties {

    private boolean enabled;
    private String username;
    private String password;
    private String realName;
    private Long schoolId;
}
