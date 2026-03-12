package com.major.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.major.annotation.OperationLog;
import com.major.domain.entity.OperationLogEntity;
import com.major.mapper.OperationLogMapper;
import com.major.security.LoginUser;
import com.major.security.SecurityUtils;
import java.util.Arrays;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Aspect
@Component
public class OperationLogAspect {

    private final OperationLogMapper operationLogMapper;
    private final ObjectMapper objectMapper;

    public OperationLogAspect(OperationLogMapper operationLogMapper, ObjectMapper objectMapper) {
        this.operationLogMapper = operationLogMapper;
        this.objectMapper = objectMapper;
    }

    @Around("@annotation(com.major.annotation.OperationLog)")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        OperationLog operationLog = signature.getMethod().getAnnotation(OperationLog.class);
        OperationLogEntity entity = new OperationLogEntity();
        entity.setModule(operationLog.module());
        entity.setOperation(operationLog.action());
        try {
            LoginUser loginUser = SecurityUtils.getLoginUser();
            entity.setUserId(loginUser.getUserId());
            entity.setUsername(loginUser.getUsername());
        } catch (Exception ignored) {
        }
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes != null) {
            HttpServletRequest request = attributes.getRequest();
            if (request != null) {
                entity.setRequestMethod(request.getMethod());
                entity.setRequestUri(request.getRequestURI());
            }
        }
        entity.setRequestBody(buildRequestSummary(joinPoint.getArgs()));
        entity.setSuccess(1);
        try {
            Object result = joinPoint.proceed();
            operationLogMapper.insert(entity);
            return result;
        } catch (Throwable ex) {
            entity.setSuccess(0);
            entity.setErrorMessage(ex.getMessage());
            operationLogMapper.insert(entity);
            throw ex;
        }
    }

    private String buildRequestSummary(Object[] args) {
        try {
            return Arrays.stream(args)
                    .filter(arg -> !(arg instanceof MultipartFile))
                    .map(arg -> {
                        try {
                            return objectMapper.writeValueAsString(arg);
                        } catch (Exception ex) {
                            return String.valueOf(arg);
                        }
                    })
                    .collect(Collectors.joining(";"));
        } catch (Exception ex) {
            log.warn("Build request summary failed", ex);
            return null;
        }
    }
}
