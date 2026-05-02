package com.major.common.util;

public final class CacheKeyUtils {

    private CacheKeyUtils() {
    }

    public static String dashboardOverviewKey(Integer deptId, Integer majorId, Integer year) {
        return join(deptId, majorId, year);
    }

    public static String dashboardScoreKey(Integer deptId, Integer majorId, Integer year) {
        return join(deptId, majorId, year);
    }

    public static String dashboardWarningMetricsKey(Integer deptId, Integer majorId, Integer year) {
        return join(deptId, majorId, year);
    }

    public static String dashboardRankKey(Integer deptId, Integer majorId, String metric, Integer year, Integer limit) {
        return join(deptId, majorId, metric, year, limit);
    }

    private static String join(Object... parts) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            if (i > 0) {
                builder.append(':');
            }
            builder.append(parts[i] == null ? "null" : parts[i].toString());
        }
        return builder.toString();
    }
}
