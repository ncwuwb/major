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
    <div class="login-view__panel">
      <div class="login-view__brand">
        <div class="login-view__logo">M</div>
        <h1>高校专业数据资源监测平台</h1>
        <p class="muted">专业建设 · 数据监测 · 质量评估</p>
      </div>

      <div class="page-card login-card">
        <div class="login-card__header">
          <h2>登录系统</h2>
          <p class="muted">请输入账号密码进入系统</p>
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
            <span class="muted">默认账号</span>
            <strong>admin / admin123456</strong>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-view {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background:
    radial-gradient(circle at 30% 20%, rgba(15, 157, 138, 0.08), transparent 40%),
    radial-gradient(circle at 70% 80%, rgba(242, 155, 56, 0.06), transparent 40%),
    var(--bg-page, #edf3f6);
}

.login-view__panel {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 28px;
  padding: 40px 20px;
  width: 100%;
  max-width: 460px;
}

.login-view__brand {
  text-align: center;
}

.login-view__logo {
  display: inline-flex;
  width: 56px;
  height: 56px;
  align-items: center;
  justify-content: center;
  border-radius: 18px;
  background: linear-gradient(135deg, var(--brand-primary), var(--brand-accent));
  color: white;
  font-size: 28px;
  font-weight: 900;
  box-shadow: 0 10px 24px rgba(15, 157, 138, 0.22);
  margin-bottom: 18px;
}

.login-view__brand h1 {
  margin: 0;
  font-size: 24px;
  letter-spacing: 0.04em;
}

.login-view__brand p {
  margin: 8px 0 0;
}

.login-card {
  width: 100%;
  padding: 28px;
}

.login-card__header {
  margin-bottom: 20px;
}

.login-card__header h2 {
  margin: 0 0 6px;
  font-size: 20px;
}

.login-card__header p {
  margin: 0;
}

.login-card__tips {
  display: grid;
  gap: 14px;
  margin-top: 22px;
  padding-top: 16px;
  border-top: 1px dashed var(--line-soft);
}

.login-card__tips strong,
.login-card__tips span {
  display: block;
}

.login-card__tips strong {
  margin-top: 4px;
}

@media (max-width: 520px) {
  .login-view__panel {
    padding: 24px 16px;
  }

  .login-card {
    padding: 20px;
  }
}
</style>
