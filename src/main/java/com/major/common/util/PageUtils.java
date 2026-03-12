package com.major.common.util;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.major.common.response.PageResponse;

public final class PageUtils {

    private PageUtils() {
    }

    public static <T> PageResponse<T> toPageResponse(Page<T> page) {
        return new PageResponse<>(page.getTotal(), page.getCurrent(), page.getSize(), page.getRecords());
    }
}
