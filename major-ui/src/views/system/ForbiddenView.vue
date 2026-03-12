<template>
  <div class="page-shell">
    <div class="page-card forbidden-view">
      <h1>403</h1>
      <h2>当前账号没有访问这个页面的权限</h2>
      <p>你可以返回首页继续演示，也可以切换到权限更高的账号进行操作。</p>
      <router-link class="forbidden-view__link" to="/dashboard">返回首页看板</router-link>
    </div>
  </div>
</template>

<style scoped>
.forbidden-view {
  display: flex;
  min-height: 70vh;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  text-align: center;
  padding: 24px;
}

h1 {
  margin: 0;
  color: var(--brand-danger);
  font-size: 88px;
}

h2,
p {
  margin: 0;
}

p {
  color: var(--text-secondary);
}

.forbidden-view__link {
  margin-top: 10px;
  padding: 12px 18px;
  border-radius: 999px;
  background: var(--brand-primary);
  color: #fff;
}
</style>