package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.major.common.exception.BusinessException;
import com.major.common.model.PageQuery;
import com.major.common.response.PageResponse;
import com.major.common.util.PageUtils;
import com.major.domain.entity.IndicatorRuleEntity;
import com.major.mapper.IndicatorRuleMapper;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class SystemConfigService {

    private final IndicatorRuleMapper indicatorRuleMapper;

    public SystemConfigService(IndicatorRuleMapper indicatorRuleMapper) {
        this.indicatorRuleMapper = indicatorRuleMapper;
    }

    public PageResponse<IndicatorRuleEntity> pageIndicatorRules(PageQuery pageQuery, String keyword) {
        QueryWrapper<IndicatorRuleEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w.like("indicator_name", keyword).or().like("indicator_code", keyword));
        }
        Page<IndicatorRuleEntity> page = indicatorRuleMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public IndicatorRuleEntity getIndicatorRule(Integer id) {
        IndicatorRuleEntity entity = indicatorRuleMapper.selectById(id);
        if (entity == null || entity.getDeleted() == 1) {
            throw new BusinessException(404, "指标规则不存在");
        }
        return entity;
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void saveIndicatorRule(IndicatorRuleEntity entity) {
        ensureUniqueCode(entity.getIndicatorCode(), null);
        indicatorRuleMapper.insert(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void updateIndicatorRule(Integer id, IndicatorRuleEntity entity) {
        getIndicatorRule(id);
        ensureUniqueCode(entity.getIndicatorCode(), id);
        entity.setRuleId(id);
        indicatorRuleMapper.updateById(entity);
    }

    @CacheEvict(cacheNames = {"dashboard:overview", "dashboard:score", "dashboard:warningMetrics"}, allEntries = true)
    public void deleteIndicatorRule(Integer id) {
        getIndicatorRule(id);
        indicatorRuleMapper.deleteById(id);
    }

    private void ensureUniqueCode(String indicatorCode, Integer excludeId) {
        QueryWrapper<IndicatorRuleEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("indicator_code", indicatorCode).eq("deleted", 0);
        if (excludeId != null) {
            wrapper.ne("rule_id", excludeId);
        }
        if (indicatorRuleMapper.selectCount(wrapper) > 0) {
            throw new BusinessException(400, "指标编码已存在");
        }
    }
}
