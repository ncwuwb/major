package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.major.common.constant.IndicatorConstants;
import com.major.domain.dto.DashboardFilterRequest;
import com.major.domain.dto.DashboardRankRequest;
import com.major.domain.dto.DashboardTrendRequest;
import com.major.domain.entity.IndicatorRuleEntity;
import com.major.domain.vo.DashboardOverviewVO;
import com.major.domain.vo.DashboardRankVO;
import com.major.domain.vo.DashboardScoreVO;
import com.major.domain.vo.DashboardTrendPointVO;
import com.major.domain.vo.WarningDetailVO;
import com.major.domain.vo.WarningMetricVO;
import com.major.mapper.DashboardMapper;
import com.major.mapper.IndicatorRuleMapper;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

    private final DashboardMapper dashboardMapper;
    private final IndicatorRuleMapper indicatorRuleMapper;
    private final DataScopeService dataScopeService;
    private final WarningService warningService;

    public DashboardService(DashboardMapper dashboardMapper, IndicatorRuleMapper indicatorRuleMapper,
                            DataScopeService dataScopeService, WarningService warningService) {
        this.dashboardMapper = dashboardMapper;
        this.indicatorRuleMapper = indicatorRuleMapper;
        this.dataScopeService = dataScopeService;
        this.warningService = warningService;
    }

    public DashboardOverviewVO overview(DashboardFilterRequest request) {
        Integer deptId = dataScopeService.resolveRequestedDeptId(request.getDeptId(), request.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(request.getMajorId());
        DashboardOverviewVO overview = dashboardMapper.selectOverview(deptId, majorId, request.getYear());
        return overview == null ? new DashboardOverviewVO() : overview;
    }

    public List<DashboardTrendPointVO> trend(DashboardTrendRequest request) {
        Integer deptId = dataScopeService.resolveRequestedDeptId(request.getDeptId(), request.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(request.getMajorId());
        int endYear = request.getEndYear() == null ? LocalDate.now().getYear() : request.getEndYear();
        int startYear = request.getStartYear() == null ? endYear - 4 : request.getStartYear();
        if (IndicatorConstants.PHD_RATE.equals(request.getMetric())) {
            DashboardOverviewVO overview = dashboardMapper.selectOverview(deptId, majorId, endYear);
            BigDecimal phdRate = overview == null || overview.getPhdRate() == null ? BigDecimal.ZERO : overview.getPhdRate();
            List<DashboardTrendPointVO> result = new ArrayList<>();
            for (int year = startYear; year <= endYear; year++) {
                DashboardTrendPointVO point = new DashboardTrendPointVO();
                point.setStatYear(year);
                point.setMetricValue(phdRate);
                result.add(point);
            }
            return result;
        }
        if (IndicatorConstants.COURSE_COUNT.equals(request.getMetric())) {
            DashboardOverviewVO overview = dashboardMapper.selectOverview(deptId, majorId, endYear);
            BigDecimal courseCount = overview == null || overview.getCourseCount() == null
                ? BigDecimal.ZERO
                : BigDecimal.valueOf(overview.getCourseCount());
            List<DashboardTrendPointVO> result = new ArrayList<>();
            for (int year = startYear; year <= endYear; year++) {
                DashboardTrendPointVO point = new DashboardTrendPointVO();
                point.setStatYear(year);
                point.setMetricValue(courseCount);
                result.add(point);
            }
            return result;
        }
        return dashboardMapper.selectTrend(request.getMetric(), deptId, majorId, startYear, endYear);
    }

    public List<DashboardRankVO> rank(DashboardRankRequest request) {
        Integer majorId = dataScopeService.resolveRequestedMajorId(request.getMajorId());
        Integer deptId = dataScopeService.resolveRequestedDeptId(request.getDeptId(), majorId);
        Integer limit = request.getLimit() == null ? 10 : request.getLimit();
        if (majorId != null) {
            List<DashboardRankVO> all = dashboardMapper.selectRank(request.getMetric(), deptId, null, request.getYear(), 1000);
            List<DashboardRankVO> filtered = new ArrayList<>();
            for (DashboardRankVO item : all) {
                if (majorId.equals(item.getMajorId())) {
                    filtered.add(item);
                }
            }
            return filtered;
        }
        return dashboardMapper.selectRank(request.getMetric(), deptId, null, request.getYear(), limit);
    }

    public List<DashboardScoreVO> score(DashboardFilterRequest request) {
        Integer deptId = dataScopeService.resolveRequestedDeptId(request.getDeptId(), request.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(request.getMajorId());
        List<DashboardScoreVO> scores = dashboardMapper.selectScore(deptId, majorId, request.getYear());
        Map<String, BigDecimal> weightMap = new HashMap<>();
        for (IndicatorRuleEntity rule : indicatorRuleMapper.selectList(new QueryWrapper<IndicatorRuleEntity>().eq("deleted", 0))) {
            weightMap.put(rule.getIndicatorCode(), rule.getWeight() == null ? BigDecimal.ZERO : rule.getWeight());
        }
        for (DashboardScoreVO score : scores) {
            BigDecimal total = BigDecimal.ZERO;
            total = total.add(metricScore(score.getPhdRate(), weightMap.get(IndicatorConstants.PHD_RATE)));
            total = total.add(metricScore(score.getAdmissionCompletionRate(), weightMap.get(IndicatorConstants.ADMISSION_COMPLETION_RATE)));
            total = total.add(metricScore(score.getFundingUtilizationRate(), weightMap.get(IndicatorConstants.FUNDING_UTILIZATION_RATE)));
            total = total.add(metricScore(score.getEmploymentRate(), weightMap.get(IndicatorConstants.EMPLOYMENT_RATE)));
            total = total.add(metricScore(score.getPostgraduateRate(), weightMap.get(IndicatorConstants.POSTGRADUATE_RATE)));
            score.setTotalScore(total.setScale(2, RoundingMode.HALF_UP));
        }
        return scores;
    }

    public List<WarningDetailVO> warnings(DashboardFilterRequest request) {
        Integer deptId = dataScopeService.resolveRequestedDeptId(request.getDeptId(), request.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(request.getMajorId());
        return dashboardMapper.selectWarnings(deptId, majorId, request.getYear());
    }

    public void recalculateWarnings() {
        warningService.recalculateAll();
    }

    public List<WarningMetricVO> warningMetrics(DashboardFilterRequest request) {
        Integer deptId = dataScopeService.resolveRequestedDeptId(request.getDeptId(), request.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(request.getMajorId());
        DashboardOverviewVO overview = dashboardMapper.selectOverview(deptId, majorId, request.getYear());
        DashboardOverviewVO safe = overview == null ? new DashboardOverviewVO() : overview;

        List<IndicatorRuleEntity> rules =
            indicatorRuleMapper.selectList(new QueryWrapper<IndicatorRuleEntity>().eq("deleted", 0).eq("enabled", 1));

        List<WarningMetricVO> result = new ArrayList<>();
        for (IndicatorRuleEntity rule : rules) {
            WarningMetricVO vo = new WarningMetricVO();
            vo.setIndicatorCode(rule.getIndicatorCode());
            vo.setIndicatorName(rule.getIndicatorName());
            vo.setCompareType(rule.getCompareType());
            vo.setThresholdValue(rule.getThresholdValue());

            BigDecimal actual = resolveActualMetricValue(rule.getIndicatorCode(), safe);
            vo.setActualValue(actual);

            String status = evaluate(rule.getCompareType(), actual, rule.getThresholdValue()) ? "PASS" : "WARN";
            vo.setStatus(status);

            vo.setAttainmentRate(calcAttainment(rule.getCompareType(), actual, rule.getThresholdValue()));
            result.add(vo);
        }

        return result;
    }

    private BigDecimal metricScore(BigDecimal metric, BigDecimal weight) {
        BigDecimal safeMetric = metric == null ? BigDecimal.ZERO : metric;
        BigDecimal safeWeight = weight == null ? BigDecimal.ZERO : weight;
        return safeMetric.multiply(safeWeight).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    }

    private BigDecimal resolveActualMetricValue(String indicatorCode, DashboardOverviewVO overview) {
        if (IndicatorConstants.PHD_RATE.equals(indicatorCode)) {
            return overview.getPhdRate();
        }
        if (IndicatorConstants.ADMISSION_COMPLETION_RATE.equals(indicatorCode)) {
            return overview.getAdmissionCompletionRate();
        }
        if (IndicatorConstants.FUNDING_UTILIZATION_RATE.equals(indicatorCode)) {
            return overview.getFundingUtilizationRate();
        }
        if (IndicatorConstants.EMPLOYMENT_RATE.equals(indicatorCode)) {
            return overview.getEmploymentRate();
        }
        if (IndicatorConstants.POSTGRADUATE_RATE.equals(indicatorCode)) {
            return overview.getPostgraduateRate();
        }
        return BigDecimal.ZERO;
    }

    private boolean evaluate(String compareType, BigDecimal actual, BigDecimal threshold) {
        BigDecimal safeActual = actual == null ? BigDecimal.ZERO : actual;
        BigDecimal safeThreshold = threshold == null ? BigDecimal.ZERO : threshold;
        if ("GT".equalsIgnoreCase(compareType)) {
            return safeActual.compareTo(safeThreshold) <= 0;
        }
        return safeActual.compareTo(safeThreshold) >= 0;
    }

    private BigDecimal calcAttainment(String compareType, BigDecimal actual, BigDecimal threshold) {
        BigDecimal safeActual = actual == null ? BigDecimal.ZERO : actual;
        BigDecimal safeThreshold = threshold == null ? BigDecimal.ZERO : threshold;
        if (safeThreshold.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        if ("GT".equalsIgnoreCase(compareType)) {
            if (safeActual.compareTo(BigDecimal.ZERO) <= 0) {
                return BigDecimal.ZERO;
            }
            return safeThreshold.multiply(BigDecimal.valueOf(100)).divide(safeActual, 2, RoundingMode.HALF_UP);
        }
        return safeActual.multiply(BigDecimal.valueOf(100)).divide(safeThreshold, 2, RoundingMode.HALF_UP);
    }
}