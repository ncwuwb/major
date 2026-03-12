package com.major.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "major.jwt")
public class JwtProperties {

    private String secret;
    private long expireMillis;
}
