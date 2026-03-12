package com.major.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.major.common.exception.BusinessException;
import com.major.common.model.PageQuery;
import com.major.common.response.PageResponse;
import com.major.common.util.PageUtils;
import com.major.domain.entity.AchievementEntity;
import com.major.domain.entity.AdmissionEntity;
import com.major.domain.entity.CompetitionEntity;
import com.major.domain.entity.FundingEntity;
import com.major.domain.entity.GraduateOutcomeEntity;
import com.major.domain.entity.InternationalExchangeEntity;
import com.major.domain.entity.StudentEntity;
import com.major.domain.entity.TeacherEntity;
import com.major.mapper.AchievementMapper;
import com.major.mapper.AdmissionMapper;
import com.major.mapper.CompetitionMapper;
import com.major.mapper.FundingMapper;
import com.major.mapper.GraduateOutcomeMapper;
import com.major.mapper.InternationalExchangeMapper;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class AnnualDataService {

    private final AdmissionMapper admissionMapper;
    private final FundingMapper fundingMapper;
    private final GraduateOutcomeMapper graduateOutcomeMapper;
    private final AchievementMapper achievementMapper;
    private final CompetitionMapper competitionMapper;
    private final InternationalExchangeMapper internationalExchangeMapper;
    private final DataScopeService dataScopeService;
    private final ReferenceAssertService referenceAssertService;
    private final WarningService warningService;

    public AnnualDataService(AdmissionMapper admissionMapper, FundingMapper fundingMapper,
                             GraduateOutcomeMapper graduateOutcomeMapper, AchievementMapper achievementMapper,
                             CompetitionMapper competitionMapper, InternationalExchangeMapper internationalExchangeMapper,
                             DataScopeService dataScopeService, ReferenceAssertService referenceAssertService,
                             @Lazy WarningService warningService) {
        this.admissionMapper = admissionMapper;
        this.fundingMapper = fundingMapper;
        this.graduateOutcomeMapper = graduateOutcomeMapper;
        this.achievementMapper = achievementMapper;
        this.competitionMapper = competitionMapper;
        this.internationalExchangeMapper = internationalExchangeMapper;
        this.dataScopeService = dataScopeService;
        this.referenceAssertService = referenceAssertService;
        this.warningService = warningService;
    }

    public PageResponse<AdmissionEntity> pageAdmissions(PageQuery pageQuery, Integer majorId, Integer year) {
        QueryWrapper<AdmissionEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyMajorScope(wrapper, "major_id");
        if (majorId != null) {
            dataScopeService.assertCanAccessMajor(majorId);
            wrapper.eq("major_id", majorId);
        }
        if (year != null) {
            wrapper.eq("stat_year", year);
        }
        wrapper.orderByDesc("stat_year");
        Page<AdmissionEntity> page = admissionMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public AdmissionEntity getAdmission(Integer id) {
        AdmissionEntity entity = admissionMapper.selectById(id);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Admission record not found");
        }
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        return entity;
    }

    public void saveAdmission(AdmissionEntity entity) {
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        ensureUniqueYearRecord(admissionMapper.selectCount(new QueryWrapper<AdmissionEntity>()
                        .eq("major_id", entity.getMajorId()).eq("stat_year", entity.getStatYear()).eq("deleted", 0)) == 0,
                "Admission record already exists for this major and year");
        admissionMapper.insert(entity);
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public void updateAdmission(Integer id, AdmissionEntity entity) {
        AdmissionEntity existing = getAdmission(id);
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        ensureUniqueYearRecord(admissionMapper.selectCount(new QueryWrapper<AdmissionEntity>()
                        .eq("major_id", entity.getMajorId()).eq("stat_year", entity.getStatYear()).eq("deleted", 0)
                        .ne("admission_id", id)) == 0,
                "Admission record already exists for this major and year");
        entity.setAdmissionId(id);
        admissionMapper.updateById(entity);
        warningService.recalculateByMajorAndYear(existing.getMajorId(), existing.getStatYear());
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public void deleteAdmission(Integer id) {
        AdmissionEntity entity = getAdmission(id);
        admissionMapper.deleteById(id);
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public PageResponse<FundingEntity> pageFundings(PageQuery pageQuery, Integer majorId, Integer year) {
        QueryWrapper<FundingEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyMajorScope(wrapper, "major_id");
        if (majorId != null) {
            dataScopeService.assertCanAccessMajor(majorId);
            wrapper.eq("major_id", majorId);
        }
        if (year != null) {
            wrapper.eq("stat_year", year);
        }
        wrapper.orderByDesc("stat_year");
        Page<FundingEntity> page = fundingMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public FundingEntity getFunding(Integer id) {
        FundingEntity entity = fundingMapper.selectById(id);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Funding record not found");
        }
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        return entity;
    }

    public void saveFunding(FundingEntity entity) {
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        ensureUniqueYearRecord(fundingMapper.selectCount(new QueryWrapper<FundingEntity>()
                        .eq("major_id", entity.getMajorId()).eq("stat_year", entity.getStatYear()).eq("deleted", 0)) == 0,
                "Funding record already exists for this major and year");
        fundingMapper.insert(entity);
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public void updateFunding(Integer id, FundingEntity entity) {
        FundingEntity existing = getFunding(id);
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        ensureUniqueYearRecord(fundingMapper.selectCount(new QueryWrapper<FundingEntity>()
                        .eq("major_id", entity.getMajorId()).eq("stat_year", entity.getStatYear()).eq("deleted", 0)
                        .ne("funding_id", id)) == 0,
                "Funding record already exists for this major and year");
        entity.setFundingId(id);
        fundingMapper.updateById(entity);
        warningService.recalculateByMajorAndYear(existing.getMajorId(), existing.getStatYear());
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public void deleteFunding(Integer id) {
        FundingEntity entity = getFunding(id);
        fundingMapper.deleteById(id);
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public PageResponse<GraduateOutcomeEntity> pageGraduateOutcomes(PageQuery pageQuery, Integer majorId, Integer year) {
        QueryWrapper<GraduateOutcomeEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyMajorScope(wrapper, "major_id");
        if (majorId != null) {
            dataScopeService.assertCanAccessMajor(majorId);
            wrapper.eq("major_id", majorId);
        }
        if (year != null) {
            wrapper.eq("stat_year", year);
        }
        wrapper.orderByDesc("stat_year");
        Page<GraduateOutcomeEntity> page = graduateOutcomeMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public GraduateOutcomeEntity getGraduateOutcome(Integer id) {
        GraduateOutcomeEntity entity = graduateOutcomeMapper.selectById(id);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Graduate outcome record not found");
        }
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        return entity;
    }

    public void saveGraduateOutcome(GraduateOutcomeEntity entity) {
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        referenceAssertService.requireMajor(entity.getMajorId());
        ensureUniqueYearRecord(graduateOutcomeMapper.selectCount(new QueryWrapper<GraduateOutcomeEntity>()
                        .eq("major_id", entity.getMajorId()).eq("stat_year", entity.getStatYear()).eq("deleted", 0)) == 0,
                "Graduate outcome record already exists for this major and year");
        graduateOutcomeMapper.insert(entity);
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public void updateGraduateOutcome(Integer id, GraduateOutcomeEntity entity) {
        GraduateOutcomeEntity existing = getGraduateOutcome(id);
        dataScopeService.assertCanAccessMajor(entity.getMajorId());
        ensureUniqueYearRecord(graduateOutcomeMapper.selectCount(new QueryWrapper<GraduateOutcomeEntity>()
                        .eq("major_id", entity.getMajorId()).eq("stat_year", entity.getStatYear()).eq("deleted", 0)
                        .ne("outcome_id", id)) == 0,
                "Graduate outcome record already exists for this major and year");
        entity.setOutcomeId(id);
        graduateOutcomeMapper.updateById(entity);
        warningService.recalculateByMajorAndYear(existing.getMajorId(), existing.getStatYear());
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public void deleteGraduateOutcome(Integer id) {
        GraduateOutcomeEntity entity = getGraduateOutcome(id);
        graduateOutcomeMapper.deleteById(id);
        warningService.recalculateByMajorAndYear(entity.getMajorId(), entity.getStatYear());
    }

    public PageResponse<AchievementEntity> pageAchievements(PageQuery pageQuery, Integer teacherId, Integer year, String keyword) {
        QueryWrapper<AchievementEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        Integer scopedDeptId = dataScopeService.resolveCurrentDeptId();
        if (scopedDeptId != null) {
            wrapper.inSql("teacher_id", "select teacher_id from teacher where dept_id = " + scopedDeptId + " and deleted = 0");
        }
        if (teacherId != null) {
            TeacherEntity teacher = referenceAssertService.requireTeacher(teacherId);
            dataScopeService.assertCanAccessDept(teacher.getDeptId());
            wrapper.eq("teacher_id", teacherId);
        }
        if (year != null) {
            wrapper.eq("stat_year", year);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.like("name", keyword);
        }
        Page<AchievementEntity> page = achievementMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public AchievementEntity getAchievement(Integer id) {
        AchievementEntity entity = achievementMapper.selectById(id);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Achievement record not found");
        }
        TeacherEntity teacher = referenceAssertService.requireTeacher(entity.getTeacherId());
        dataScopeService.assertCanAccessDept(teacher.getDeptId());
        return entity;
    }

    public void saveAchievement(AchievementEntity entity) {
        TeacherEntity teacher = referenceAssertService.requireTeacher(entity.getTeacherId());
        dataScopeService.assertCanAccessDept(teacher.getDeptId());
        achievementMapper.insert(entity);
    }

    public void updateAchievement(Integer id, AchievementEntity entity) {
        getAchievement(id);
        TeacherEntity teacher = referenceAssertService.requireTeacher(entity.getTeacherId());
        dataScopeService.assertCanAccessDept(teacher.getDeptId());
        entity.setAchievementId(id);
        achievementMapper.updateById(entity);
    }

    public void deleteAchievement(Integer id) {
        getAchievement(id);
        achievementMapper.deleteById(id);
    }

    public PageResponse<CompetitionEntity> pageCompetitions(PageQuery pageQuery, Integer studentId, Integer year, String keyword) {
        QueryWrapper<CompetitionEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyStudentScope(wrapper, "student_id");
        if (studentId != null) {
            StudentEntity student = referenceAssertService.requireStudent(studentId);
            dataScopeService.assertCanAccessMajor(student.getMajorId());
            wrapper.eq("student_id", studentId);
        }
        if (year != null) {
            wrapper.eq("stat_year", year);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.like("name", keyword);
        }
        Page<CompetitionEntity> page = competitionMapper.selectPage(new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public CompetitionEntity getCompetition(Integer id) {
        CompetitionEntity entity = competitionMapper.selectById(id);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "Competition record not found");
        }
        StudentEntity student = referenceAssertService.requireStudent(entity.getStudentId());
        dataScopeService.assertCanAccessMajor(student.getMajorId());
        return entity;
    }

    public void saveCompetition(CompetitionEntity entity) {
        StudentEntity student = referenceAssertService.requireStudent(entity.getStudentId());
        dataScopeService.assertCanAccessMajor(student.getMajorId());
        competitionMapper.insert(entity);
    }

    public void updateCompetition(Integer id, CompetitionEntity entity) {
        getCompetition(id);
        StudentEntity student = referenceAssertService.requireStudent(entity.getStudentId());
        dataScopeService.assertCanAccessMajor(student.getMajorId());
        entity.setCompetitionId(id);
        competitionMapper.updateById(entity);
    }

    public void deleteCompetition(Integer id) {
        getCompetition(id);
        competitionMapper.deleteById(id);
    }

    public PageResponse<InternationalExchangeEntity> pageInternationalExchanges(PageQuery pageQuery, Integer studentId,
                                                                                 Integer year, String keyword) {
        QueryWrapper<InternationalExchangeEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("deleted", 0);
        dataScopeService.applyStudentScope(wrapper, "student_id");
        if (studentId != null) {
            StudentEntity student = referenceAssertService.requireStudent(studentId);
            dataScopeService.assertCanAccessMajor(student.getMajorId());
            wrapper.eq("student_id", studentId);
        }
        if (year != null) {
            wrapper.eq("stat_year", year);
        }
        if (StringUtils.hasText(keyword)) {
            wrapper.like("program", keyword);
        }
        Page<InternationalExchangeEntity> page = internationalExchangeMapper.selectPage(
                new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize()), wrapper);
        return PageUtils.toPageResponse(page);
    }

    public InternationalExchangeEntity getInternationalExchange(Integer id) {
        InternationalExchangeEntity entity = internationalExchangeMapper.selectById(id);
        if (entity == null || (entity.getDeleted() != null && entity.getDeleted() == 1)) {
            throw new BusinessException(404, "International exchange record not found");
        }
        StudentEntity student = referenceAssertService.requireStudent(entity.getStudentId());
        dataScopeService.assertCanAccessMajor(student.getMajorId());
        return entity;
    }

    public void saveInternationalExchange(InternationalExchangeEntity entity) {
        StudentEntity student = referenceAssertService.requireStudent(entity.getStudentId());
        dataScopeService.assertCanAccessMajor(student.getMajorId());
        internationalExchangeMapper.insert(entity);
    }

    public void updateInternationalExchange(Integer id, InternationalExchangeEntity entity) {
        getInternationalExchange(id);
        StudentEntity student = referenceAssertService.requireStudent(entity.getStudentId());
        dataScopeService.assertCanAccessMajor(student.getMajorId());
        entity.setExchangeId(id);
        internationalExchangeMapper.updateById(entity);
    }

    public void deleteInternationalExchange(Integer id) {
        getInternationalExchange(id);
        internationalExchangeMapper.deleteById(id);
    }

    private void ensureUniqueYearRecord(boolean condition, String message) {
        if (!condition) {
            throw new BusinessException(400, message);
        }
    }
}