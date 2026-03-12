package com.major.mapper;

import com.major.domain.vo.DashboardOverviewVO;
import com.major.domain.vo.DashboardRankVO;
import com.major.domain.vo.DashboardScoreVO;
import com.major.domain.vo.DashboardTrendPointVO;
import com.major.domain.vo.WarningDetailVO;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface DashboardMapper {

    DashboardOverviewVO selectOverview(@Param("deptId") Integer deptId,
                                       @Param("majorId") Integer majorId,
                                       @Param("year") Integer year);

    List<DashboardTrendPointVO> selectTrend(@Param("metric") String metric,
                                            @Param("deptId") Integer deptId,
                                            @Param("majorId") Integer majorId,
                                            @Param("startYear") Integer startYear,
                                            @Param("endYear") Integer endYear);

    List<DashboardRankVO> selectRank(@Param("metric") String metric,
                                     @Param("deptId") Integer deptId,
                                     @Param("majorId") Integer majorId,
                                     @Param("year") Integer year,
                                     @Param("limit") Integer limit);

    List<DashboardScoreVO> selectScore(@Param("deptId") Integer deptId,
                                       @Param("majorId") Integer majorId,
                                       @Param("year") Integer year);

    List<WarningDetailVO> selectWarnings(@Param("deptId") Integer deptId,
                                         @Param("majorId") Integer majorId,
                                         @Param("year") Integer year);
}