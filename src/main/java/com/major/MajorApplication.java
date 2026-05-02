package com.major;

import com.major.config.InitAdminProperties;
import com.major.config.JwtProperties;
import com.major.service.DashboardService;
import lombok.extern.slf4j.Slf4j;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@Slf4j
@EnableAsync
@EnableScheduling
@MapperScan("com.major.mapper")
@EnableConfigurationProperties({JwtProperties.class, InitAdminProperties.class})
@SpringBootApplication
public class MajorApplication {

    private final DashboardService dashboardService;

    public MajorApplication(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    public static void main(String[] args) {
        SpringApplication.run(MajorApplication.class, args);
    }

    @Async
    @EventListener(ApplicationReadyEvent.class)
    public void warmupDashboardOnStartup() {
        try {
            dashboardService.warmupDashboardCacheForStartup();
            log.info("Dashboard cache warmup completed successfully.");
        } catch (Exception ex) {
            log.warn("Dashboard cache warmup skipped: {}", ex.getMessage());
        }
    }
}
