package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.major.common.exception.BusinessException;
import com.major.config.InitAdminProperties;
import com.major.domain.entity.SysUserEntity;
import com.major.mapper.SysUserMapper;
import javax.annotation.PostConstruct;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class InitAdminRunner {

    private final InitAdminProperties initAdminProperties;
    private final SysUserMapper sysUserMapper;
    private final PasswordEncoder passwordEncoder;

    public InitAdminRunner(InitAdminProperties initAdminProperties, SysUserMapper sysUserMapper,
                           PasswordEncoder passwordEncoder) {
        this.initAdminProperties = initAdminProperties;
        this.sysUserMapper = sysUserMapper;
        this.passwordEncoder = passwordEncoder;
    }

    @PostConstruct
    public void initAdmin() {
        if (!initAdminProperties.isEnabled()) {
            return;
        }
        LambdaQueryWrapper<SysUserEntity> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(SysUserEntity::getUsername, initAdminProperties.getUsername())
                .eq(SysUserEntity::getDeleted, 0);
        Long count = sysUserMapper.selectCount(queryWrapper);
        if (count != null && count > 0) {
            return;
        }
        if (initAdminProperties.getSchoolId() == null) {
            throw new BusinessException("初始化管理员缺少 school-id 配置");
        }
        SysUserEntity admin = new SysUserEntity();
        admin.setUsername(initAdminProperties.getUsername());
        admin.setPassword(passwordEncoder.encode(initAdminProperties.getPassword()));
        admin.setRealName(initAdminProperties.getRealName());
        admin.setRoleCode("SCHOOL_ADMIN");
        admin.setScopeType("SCHOOL");
        admin.setScopeId(initAdminProperties.getSchoolId());
        admin.setStatus(1);
        sysUserMapper.insert(admin);
    }
}
