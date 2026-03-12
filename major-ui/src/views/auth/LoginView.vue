<script setup>
import { reactive, ref } from 'vue'
import { Lock, User } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'

import { useAuthStore } from '@/stores/auth'
import { useDictStore } from '@/stores/dicts'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const dictStore = useDictStore()

const loading = ref(false)
const formRef = ref()
const form = reactive({
  username: 'admin',
  password: 'admin123456',
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

async function handleLogin() {
  await formRef.value.validate()
  loading.value = true
  try {
    await authStore.login(form)
    await dictStore.loadAll(true)
    ElMessage.success('登录成功')
    router.replace(route.query.redirect || '/dashboard')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-view">
    <div class="login-view__hero">
      <div class="login-view__hero-card">
        <el-tag type="success" effect="dark">高校专业数据资源监测平台</el-tag>
        <h1>让答辩展示既有系统感，也有数据说服力</h1>
        <p>
          这个前端围绕“登录鉴权、基础主数据、年度业务数据、指标分析、预警与导入导出”构建，方便你在答辩时完整演示平台闭环。
        </p>
        <div class="login-view__points">
          <div>
            <strong>01</strong>
            <span>统一后台框架</span>
          </div>
          <div>
            <strong>02</strong>
            <span>首页趋势与对比图</span>
          </div>
          <div>
            <strong>03</strong>
            <span>真实接口联调</span>
          </div>
        </div>
      </div>
    </div>

    <div class="login-view__panel">
      <div class="page-card login-card">
        <div class="section-title login-card__header">
          <div>
            <h2>登录系统</h2>
            <p>默认已填入演示账号，可直接进入系统。</p>
          </div>
          <el-tag type="warning" effect="plain">Vue 3 + Spring Boot</el-tag>
        </div>

        <el-form ref="formRef" :model="form" :rules="rules" label-position="top" @keyup.enter="handleLogin">
          <el-form-item label="用户名" prop="username">
            <el-input v-model="form.username" :prefix-icon="User" placeholder="请输入用户名" />
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input v-model="form.password" :prefix-icon="Lock" type="password" show-password placeholder="请输入密码" />
          </el-form-item>
          <el-button type="primary" class="full-width" size="large" :loading="loading" @click="handleLogin">
            进入监测平台
          </el-button>
        </el-form>

        <div class="login-card__tips">
          <div>
            <span class="muted">推荐演示账号</span>
            <strong>admin / admin123456</strong>
          </div>
          <div>
            <span class="muted">演示路径</span>
            <strong>首页看板 → 数据管理 → 预警中心</strong>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-view {
  display: grid;
  min-height: 100vh;
  grid-template-columns: 1.15fr 0.85fr;
}

.login-view__hero,
.login-view__panel {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

.login-view__hero {
  background:
    radial-gradient(circle at top left, rgba(15, 157, 138, 0.22), transparent 28%),
    linear-gradient(135deg, #123740 0%, #0f5f6d 55%, #1b8d7c 100%);
  color: white;
}

.login-view__hero-card {
  max-width: 560px;
}

.login-view__hero-card h1 {
  margin: 22px 0 16px;
  font-size: 48px;
  line-height: 1.1;
}

.login-view__hero-card p {
  margin: 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 18px;
  line-height: 1.7;
}

.login-view__points {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
  margin-top: 32px;
}

.login-view__points div {
  padding: 18px;
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.08);
}

.login-view__points strong,
.login-view__points span {
  display: block;
}

.login-view__points strong {
  font-size: 22px;
}

.login-view__points span {
  margin-top: 8px;
  color: rgba(255, 255, 255, 0.82);
}

.login-card {
  width: min(100%, 500px);
  padding: 28px;
}

.login-card__header {
  margin-bottom: 16px;
}

.login-card__tips {
  display: grid;
  gap: 14px;
  margin-top: 24px;
  padding-top: 18px;
  border-top: 1px dashed var(--line-strong);
}

.login-card__tips strong,
.login-card__tips span {
  display: block;
}

.login-card__tips strong {
  margin-top: 4px;
}

@media (max-width: 1100px) {
  .login-view {
    grid-template-columns: 1fr;
  }

  .login-view__hero {
    min-height: 360px;
  }
}
</style>