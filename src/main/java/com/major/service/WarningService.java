package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.major.common.constant.CompareTypeConstants;
import com.major.domain.entity.AdmissionEntity;
import com.major.domain.entity.FundingEntity;
import com.major.domain.entity.GraduateOutcomeEntity;
import com.major.domain.entity.IndicatorRuleEntity;
import com.major.domain.entity.MajorEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.domain.entity.WarningRecordEntity;
import com.major.mapper.AdmissionMapper;
import com.major.mapper.FundingMapper;
import com.major.mapper.GraduateOutcomeMapper;
import com.major.mapper.IndicatorRuleMapper;
import com.major.mapper.MajorMapper;
import com.major.mapper.TeacherMapper;
import com.major.mapper.WarningRecordMapper;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class WarningService {

    private final MajorMapper majorMapper;
    private final TeacherMapper teacherMapper;
    private final AdmissionMapper admissionMapper;
    private final FundingMapper fundingMapper;
    private final GraduateOutcomeMapper graduateOutcomeMapper;
    private final IndicatorRuleMapper indicatorRuleMapper;
    private final WarningRecordMapper warningRecordMapper;

    public WarningService(MajorMapper majorMapper, TeacherMapper teacherMapper, AdmissionMapper admissionMapper,
                          FundingMapper fundingMapper, GraduateOutcomeMapper graduateOutcomeMapper,
                          IndicatorRuleMapper indicatorRuleMapper, WarningRecordMapper warningRecordMapper) {
        this.majorMapper = majorMapper;
        this.teacherMapper = teacherMapper;
        this.admissionMapper = admissionMapper;
        this.fundingMapper = fundingMapper;
        this.graduateOutcomeMapper = graduateOutcomeMapper;
        this.indicatorRuleMapper = indicatorRuleMapper;
        this.warningRecordMapper = warningRecordMapper;
    }

    public void recalculateByDept(Integer deptId) {
        QueryWrapper<MajorEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("dept_id", deptId).eq("deleted", 0);
        List<MajorEntity> majors = majorMapper.selectList(wrapper);
        for (MajorEntity major : majors) {
            recalculateByMajor(major.getMajorId());
        }
    }

    public void recalculateByMajor(Integer majorId) {
        for (Integer year : resolveYears(majorId)) {
            recalculateByMajorAndYear(majorId, year);
        }
    }

    public void recalculateAll() {
        QueryWrapper<MajorEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        for (MajorEntity major : majorMapper.selectList(wrapper)) {
            recalculateByMajor(major.getMajorId());
        }
    }

    @Scheduled(cron = "0 0 2 * * ?")
    public void recalculateAllScheduled() {
        recalculateAll();
    }

    public void recalculateByMajorAndYear(Integer majorId, Integer year) {
        MajorEntity major = majorMapper.selectById(majorId);
        if (major == null || (major.getDeleted() != null && major.getDeleted() == 1)) {
            return;
        }
        if (!hasYearData(majorId, year)) {
            clearAllWarnings(majorId, year);
            return;
        }
        List<IndicatorRuleEntity> rules = indicatorRuleMapper.selectList(new QueryWrapper<IndicatorRuleEntity>()
                .eq("enabled", 1).eq("deleted", 0));
        Map<String, BigDecimal> metrics = buildMetrics(major, year);
        for (IndicatorRuleEntity rule : rules) {
            BigDecimal actualValue = metrics.getOrDefault(rule.getIndicatorCode(), BigDecimal.ZERO);
            boolean triggered = isTriggered(actualValue, rule.getCompareType(), rule.getThresholdValue());
            if (triggered) {
                upsertWarning(majorId, year, rule, actualValue);
            } else {
                clearWarning(majorId, year, rule.getIndicatorCode());
            }
        }
    }

    private boolean hasYearData(Integer majorId, Integer year) {
        return admissionMapper.selectCount(new QueryWrapper<AdmissionEntity>().eq("major_id", majorId).eq("stat_year", year).eq("deleted", 0)) > 0
                || fundingMapper.selectCount(new QueryWrapper<FundingEntity>().eq("major_id", majorId).eq("stat_year", year).eq("deleted", 0)) > 0
                || graduateOutcomeMapper.selectCount(new QueryWrapper<GraduateOutcomeEntity>().eq("major_id", majorId).eq("stat_year", year).eq("deleted", 0)) > 0;
    }

    private Map<String, BigDecimal> buildMetrics(MajorEntity major, Integer year) {
        Map<String, BigDecimal> metrics = new HashMap<>();
        metrics.put("PHD_RATE", calculatePhdRate(major.getDeptId()));
        metrics.put("ADMISSION_COMPLETION_RATE", calculateAdmissionRate(major.getMajorId(), year));
        metrics.put("FUNDING_UTILIZATION_RATE", calculateFundingRate(major.getMajorId(), year));
        metrics.put("EMPLOYMENT_RATE", calculateEmploymentRate(major.getMajorId(), year));
        metrics.put("POSTGRADUATE_RATE", calculatePostgraduateRate(major.getMajorId(), year));
        return metrics;
    }

    private BigDecimal calculatePhdRate(Integer deptId) {
        List<TeacherEntity> teachers = teacherMapper.selectList(new QueryWrapper<TeacherEntity>()
                .eq("dept_id", deptId).eq("deleted", 0));
        if (teachers.isEmpty()) {
            return BigDecimal.ZERO;
        }
        long phdCount = teachers.stream().filter(t -> t.getPhdFlag() != null && t.getPhdFlag() == 1).count();
        return percentage(BigDecimal.valueOf(phdCount), BigDecimal.valueOf(teachers.size()));
    }

    private BigDecimal calculateAdmissionRate(Integer majorId, Integer year) {
        AdmissionEntity entity = admissionMapper.selectOne(new QueryWrapper<AdmissionEntity>()
                .eq("major_id", majorId).eq("stat_year", year).eq("deleted", 0).last("limit 1"));
        if (entity == null || entity.getPlanCount() == null || entity.getPlanCount() == 0 || entity.getActualCount() == null) {
            return BigDecimal.ZERO;
        }
        return percentage(BigDecimal.valueOf(entity.getActualCount()), BigDecimal.valueOf(entity.getPlanCount()));
    }

    private BigDecimal calculateFundingRate(Integer majorId, Integer year) {
        FundingEntity entity = fundingMapper.selectOne(new QueryWrapper<FundingEntity>()
                .eq("major_id", majorId).eq("stat_year", year).eq("deleted", 0).last("limit 1"));
        if (entity == null) {
            return BigDecimal.ZERO;
        }
        if (entity.getUtilizationRate() != null) {
            return entity.getUtilizationRate().setScale(2, RoundingMode.HALF_UP);
        }
        if (entity.getAllocated() == null || BigDecimal.ZERO.compareTo(entity.getAllocated()) == 0 || entity.getSpent() == null) {
            return BigDecimal.ZERO;
        }
        return percentage(entity.getSpent(), entity.getAllocated());
    }

    private BigDecimal calculateEmploymentRate(Integer majorId, Integer year) {
        GraduateOutcomeEntity entity = graduateOutcomeMapper.selectOne(new QueryWrapper<GraduateOutcomeEntity>()
                .eq("major_id", majorId).eq("stat_year", year).eq("deleted", 0).last("limit 1"));
        return entity == null || entity.getEmploymentRate() == null
                ? BigDecimal.ZERO : entity.getEmploymentRate().setScale(2, RoundingMode.HALF_UP);
    }

    private BigDecimal calculatePostgraduateRate(Integer majorId, Integer year) {
        GraduateOutcomeEntity entity = graduateOutcomeMapper.selectOne(new QueryWrapper<GraduateOutcomeEntity>()
                .eq("major_id", majorId).eq("stat_year", year).eq("deleted", 0).last("limit 1"));
        return entity == null || entity.getPostgraduateRate() == null
                ? BigDecimal.ZERO : entity.getPostgraduateRate().setScale(2, RoundingMode.HALF_UP);
    }

    private BigDecimal percentage(BigDecimal numerator, BigDecimal denominator) {
        if (denominator == null || BigDecimal.ZERO.compareTo(denominator) == 0) {
            return BigDecimal.ZERO;
        }
        return numerator.multiply(BigDecimal.valueOf(100)).divide(denominator, 2, RoundingMode.HALF_UP);
    }

    private boolean isTriggered(BigDecimal actual, String compareType, BigDecimal threshold) {
        if (CompareTypeConstants.GT.equalsIgnoreCase(compareType)) {
            return actual.compareTo(threshold) > 0;
        }
        return actual.compareTo(threshold) < 0;
    }

    private void upsertWarning(Integer majorId, Integer year, IndicatorRuleEntity rule, BigDecimal actualValue) {
        QueryWrapper<WarningRecordEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("major_id", majorId)
                .eq("stat_year", year)
                .eq("indicator_code", rule.getIndicatorCode())
                .eq("status", "ACTIVE")
                .eq("deleted", 0)
                .last("limit 1");
        WarningRecordEntity existing = warningRecordMapper.selectOne(wrapper);
        if (existing == null) {
            WarningRecordEntity entity = new WarningRecordEntity();
            entity.setMajorId(majorId);
            entity.setStatYear(year);
            entity.setIndicatorCode(rule.getIndicatorCode());
            entity.setIndicatorName(rule.getIndicatorName());
            entity.setCompareType(rule.getCompareType());
            entity.setThresholdValue(rule.getThresholdValue());
            entity.setActualValue(actualValue);
            entity.setStatus("ACTIVE");
            entity.setMessage(String.format("%s actual %s threshold %s", rule.getIndicatorName(), actualValue, rule.getThresholdValue()));
            entity.setTriggeredAt(LocalDateTime.now());
            warningRecordMapper.insert(entity);
            return;
        }
        existing.setThresholdValue(rule.getThresholdValue());
        existing.setActualValue(actualValue);
        existing.setMessage(String.format("%s actual %s threshold %s", rule.getIndicatorName(), actualValue, rule.getThresholdValue()));
        warningRecordMapper.updateById(existing);
    }

    private void clearWarning(Integer majorId, Integer year, String indicatorCode) {
        QueryWrapper<WarningRecordEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("major_id", majorId)
                .eq("stat_year", year)
                .eq("indicator_code", indicatorCode)
                .eq("status", "ACTIVE")
                .eq("deleted", 0);
        List<WarningRecordEntity> warnings = warningRecordMapper.selectList(wrapper);
        for (WarningRecordEntity warning : warnings) {
            warning.setStatus("CLEARED");
            warning.setClearedAt(LocalDateTime.now());
            warningRecordMapper.updateById(warning);
        }
    }

    private void clearAllWarnings(Integer majorId, Integer year) {
        QueryWrapper<WarningRecordEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("major_id", majorId)
                .eq("stat_year", year)
                .eq("status", "ACTIVE")
                .eq("deleted", 0);
        List<WarningRecordEntity> warnings = warningRecordMapper.selectList(wrapper);
        for (WarningRecordEntity warning : warnings) {
            warning.setStatus("CLEARED");
            warning.setClearedAt(LocalDateTime.now());
            warningRecordMapper.updateById(warning);
        }
    }

    private List<Integer> resolveYears(Integer majorId) {
        Set<Integer> years = new HashSet<>();
        admissionMapper.selectList(new QueryWrapper<AdmissionEntity>().eq("major_id", majorId).eq("deleted", 0))
                .forEach(item -> years.add(item.getStatYear()));
        fundingMapper.selectList(new QueryWrapper<FundingEntity>().eq("major_id", majorId).eq("deleted", 0))
                .forEach(item -> years.add(item.getStatYear()));
        graduateOutcomeMapper.selectList(new QueryWrapper<GraduateOutcomeEntity>().eq("major_id", majorId).eq("deleted", 0))
                .forEach(item -> years.add(item.getStatYear()));
        if (years.isEmpty()) {
            years.add(LocalDate.now().getYear());
        }
        return new ArrayList<>(years);
    }
}