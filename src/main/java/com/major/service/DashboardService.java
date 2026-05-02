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
import com.major.domain.entity.DepartmentEntity;
import com.major.domain.entity.MajorEntity;
import com.major.domain.entity.StudentEntity;
import com.major.mapper.DashboardMapper;
import com.major.mapper.DepartmentMapper;
import com.major.mapper.IndicatorRuleMapper;
import com.major.mapper.MajorMapper;
import com.major.mapper.StudentMapper;
import com.major.common.util.CacheKeyUtils;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

    private final DashboardMapper dashboardMapper;
    private final IndicatorRuleMapper indicatorRuleMapper;
    private final DataScopeService dataScopeService;
    private final WarningService warningService;
    private final DepartmentMapper departmentMapper;
    private final MajorMapper majorMapper;
    private final StudentMapper studentMapper;
    private final CacheManager cacheManager;

    public DashboardService(DashboardMapper dashboardMapper, IndicatorRuleMapper indicatorRuleMapper,
                            DataScopeService dataScopeService, WarningService warningService,
                            DepartmentMapper departmentMapper, MajorMapper majorMapper,
                            StudentMapper studentMapper, CacheManager cacheManager) {
        this.dashboardMapper = dashboardMapper;
        this.indicatorRuleMapper = indicatorRuleMapper;
        this.dataScopeService = dataScopeService;
        this.warningService = warningService;
        this.departmentMapper = departmentMapper;
        this.majorMapper = majorMapper;
        this.studentMapper = studentMapper;
        this.cacheManager = cacheManager;
    }

    @Cacheable(cacheNames = "dashboard:overview", key = "T(com.major.common.util.CacheKeyUtils).dashboardOverviewKey(#request.deptId, #request.majorId, #request.year)")
    public DashboardOverviewVO overview(DashboardFilterRequest request) {
        DashboardFilterRequest safeRequest = defaultFilter(request);
        Integer deptId = dataScopeService.resolveRequestedDeptId(safeRequest.getDeptId(), safeRequest.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(safeRequest.getMajorId());
        return buildOverview(deptId, majorId, safeRequest.getYear());
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

    @Cacheable(cacheNames = "dashboard:rank", key = "T(com.major.common.util.CacheKeyUtils).dashboardRankKey(#request.deptId, #request.majorId, #request.metric, #request.year, #request.limit)")
    public List<DashboardRankVO> rank(DashboardRankRequest request) {
        DashboardRankRequest safeRequest = defaultRankRequest(request);
        Integer majorId = dataScopeService.resolveRequestedMajorId(safeRequest.getMajorId());
        Integer deptId = dataScopeService.resolveRequestedDeptId(safeRequest.getDeptId(), majorId);
        Integer limit = safeRequest.getLimit() == null ? 10 : safeRequest.getLimit();
        return buildRank(deptId, majorId, safeRequest.getYear(), safeRequest.getMetric(), limit);
    }

    @Cacheable(cacheNames = "dashboard:score", key = "T(com.major.common.util.CacheKeyUtils).dashboardScoreKey(#request.deptId, #request.majorId, #request.year)")
    public List<DashboardScoreVO> score(DashboardFilterRequest request) {
        DashboardFilterRequest safeRequest = defaultFilter(request);
        Integer deptId = dataScopeService.resolveRequestedDeptId(safeRequest.getDeptId(), safeRequest.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(safeRequest.getMajorId());
        return buildScore(deptId, majorId, safeRequest.getYear());
    }

    public List<WarningDetailVO> warnings(DashboardFilterRequest request) {
        DashboardFilterRequest safeRequest = defaultFilter(request);
        Integer deptId = dataScopeService.resolveRequestedDeptId(safeRequest.getDeptId(), safeRequest.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(safeRequest.getMajorId());
        return dashboardMapper.selectWarnings(deptId, majorId, safeRequest.getYear());
    }

    public void recalculateWarnings() {
        warningService.recalculateAll();
    }

    public void warmupDashboardCache(DashboardFilterRequest request) {
        DashboardFilterRequest safeRequest = defaultFilter(request);
        Integer deptId = safeRequest.getDeptId();
        Integer majorId = safeRequest.getMajorId();
        Integer year = safeRequest.getYear();
        warmupOverview(deptId, majorId, year);
        warmupScore(deptId, majorId, year);
        warmupWarningMetrics(deptId, majorId, year);
        warmupRank(deptId, majorId, year, IndicatorConstants.EMPLOYMENT_RATE, 10);
    }

    public void warmupDashboardCacheForStartup() {
        Integer currentYear = LocalDate.now().getYear();
        warmupDashboardCacheForScope(null, null, currentYear);
        warmupDashboardCacheForCommonDepartments(currentYear);
        warmupDashboardCacheForCommonMajors(currentYear);
    }

    public void warmupDefaultCaches() {
        warmupDashboardCacheForStartup();
    }

    private DashboardFilterRequest defaultFilter(DashboardFilterRequest request) {
        DashboardFilterRequest safeRequest = request == null ? new DashboardFilterRequest() : request;
        if (safeRequest.getYear() == null) {
            safeRequest.setYear(LocalDate.now().getYear());
        }
        return safeRequest;
    }

    private DashboardRankRequest defaultRankRequest(DashboardRankRequest request) {
        DashboardRankRequest safeRequest = request == null ? new DashboardRankRequest() : request;
        if (safeRequest.getYear() == null) {
            safeRequest.setYear(LocalDate.now().getYear());
        }
        if (safeRequest.getLimit() == null) {
            safeRequest.setLimit(10);
        }
        return safeRequest;
    }

    public void warmupDashboardCacheForCommonDepartments(Integer year) {
        Integer currentYear = year == null ? LocalDate.now().getYear() : year;
        List<DepartmentEntity> departments = departmentMapper.selectList(new QueryWrapper<DepartmentEntity>().eq("deleted", 0));
        departments.sort((left, right) -> Integer.compare(countMajors(right.getDeptId()), countMajors(left.getDeptId())));
        int limit = Math.min(3, departments.size());
        for (int i = 0; i < limit; i++) {
            DepartmentEntity department = departments.get(i);
            warmupDashboardCacheForScope(department.getDeptId(), null, currentYear);
        }
    }

    public void warmupDashboardCacheForCommonMajors(Integer year) {
        Integer currentYear = year == null ? LocalDate.now().getYear() : year;
        List<MajorEntity> majors = majorMapper.selectList(new QueryWrapper<MajorEntity>().eq("deleted", 0));
        majors.sort((left, right) -> Integer.compare(countStudents(right.getMajorId()), countStudents(left.getMajorId())));
        int limit = Math.min(5, majors.size());
        for (int i = 0; i < limit; i++) {
            MajorEntity major = majors.get(i);
            warmupDashboardCacheForScope(major.getDeptId(), major.getMajorId(), currentYear);
        }
    }

    private void warmupDashboardCacheForScope(Integer deptId, Integer majorId, Integer year) {
        warmupOverview(deptId, majorId, year);
        warmupScore(deptId, majorId, year);
        warmupWarningMetrics(deptId, majorId, year);
        warmupRank(deptId, majorId, year, IndicatorConstants.EMPLOYMENT_RATE, 10);
    }

    public void warmupOverview(Integer deptId, Integer majorId, Integer year) {
        Cache cache = cacheManager.getCache("dashboard:overview");
        if (cache != null) {
            cache.put(CacheKeyUtils.dashboardOverviewKey(deptId, majorId, year), buildOverview(deptId, majorId, year));
        } else {
            buildOverview(deptId, majorId, year);
        }
    }

    public void warmupScore(Integer deptId, Integer majorId, Integer year) {
        Cache cache = cacheManager.getCache("dashboard:score");
        if (cache != null) {
            cache.put(CacheKeyUtils.dashboardScoreKey(deptId, majorId, year), buildScore(deptId, majorId, year));
        } else {
            buildScore(deptId, majorId, year);
        }
    }

    public void warmupWarningMetrics(Integer deptId, Integer majorId, Integer year) {
        Cache cache = cacheManager.getCache("dashboard:warningMetrics");
        if (cache != null) {
            cache.put(CacheKeyUtils.dashboardWarningMetricsKey(deptId, majorId, year), buildWarningMetrics(deptId, majorId, year));
        } else {
            buildWarningMetrics(deptId, majorId, year);
        }
    }

    public void warmupRank(Integer deptId, Integer majorId, Integer year, String metric, Integer limit) {
        Cache cache = cacheManager.getCache("dashboard:rank");
        if (cache != null) {
            cache.put(CacheKeyUtils.dashboardRankKey(deptId, majorId, metric, year, limit), buildRank(deptId, majorId, year, metric, limit));
        } else {
            buildRank(deptId, majorId, year, metric, limit);
        }
    }



    private DashboardOverviewVO buildOverview(Integer deptId, Integer majorId, Integer year) {
        DashboardOverviewVO overview = dashboardMapper.selectOverview(deptId, majorId, year);
        return overview == null ? new DashboardOverviewVO() : overview;
    }

    private List<DashboardScoreVO> buildScore(Integer deptId, Integer majorId, Integer year) {
        List<DashboardScoreVO> scores = dashboardMapper.selectScore(deptId, majorId, year);
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

    private List<WarningMetricVO> buildWarningMetrics(Integer deptId, Integer majorId, Integer year) {
        DashboardOverviewVO overview = dashboardMapper.selectOverview(deptId, majorId, year);
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
            vo.setStatus(evaluate(rule.getCompareType(), actual, rule.getThresholdValue()) ? "PASS" : "WARN");
            vo.setAttainmentRate(calcAttainment(rule.getCompareType(), actual, rule.getThresholdValue()));
            result.add(vo);
        }
        return result;
    }

    private List<DashboardRankVO> buildRank(Integer deptId, Integer majorId, Integer year, String metric, Integer limit) {
        if (majorId != null) {
            List<DashboardRankVO> all = dashboardMapper.selectRank(metric, deptId, null, year, 1000);
            List<DashboardRankVO> filtered = new ArrayList<>();
            for (DashboardRankVO item : all) {
                if (majorId.equals(item.getMajorId())) {
                    filtered.add(item);
                }
            }
            return filtered;
        }
        return dashboardMapper.selectRank(metric, deptId, null, year, limit);
    }

    private int countMajors(Integer deptId) {
        Long count = majorMapper.selectCount(new QueryWrapper<MajorEntity>().eq("deleted", 0).eq("dept_id", deptId));
        return count == null ? 0 : count.intValue();
    }

    private int countStudents(Integer majorId) {
        Long count = studentMapper.selectCount(new QueryWrapper<StudentEntity>().eq("deleted", 0).eq("major_id", majorId));
        return count == null ? 0 : count.intValue();
    }

    @Cacheable(cacheNames = "dashboard:warningMetrics", key = "T(com.major.common.util.CacheKeyUtils).dashboardWarningMetricsKey(#request.deptId, #request.majorId, #request.year)")
    public List<WarningMetricVO> warningMetrics(DashboardFilterRequest request) {
        DashboardFilterRequest safeRequest = defaultFilter(request);
        Integer deptId = dataScopeService.resolveRequestedDeptId(safeRequest.getDeptId(), safeRequest.getMajorId());
        Integer majorId = dataScopeService.resolveRequestedMajorId(safeRequest.getMajorId());
        return buildWarningMetrics(deptId, majorId, safeRequest.getYear());
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