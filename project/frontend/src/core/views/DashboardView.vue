<template>
  <div class="page">
    <nav class="navbar">
      <RouterLink to="/" class="brand">
        <span>🍽</span>
        <span>POS 點餐系統</span>
      </RouterLink>
      <div class="nav-actions">
        <span class="welcome">{{ auth.username }}</span>
        <button @click="handleLogout" class="btn-outline">登出</button>
      </div>
    </nav>

    <main class="content">
      <h2>管理後台</h2>
      <p class="hint">各模組導覽將於開發後陸續加入</p>

      <!-- 模組快速入口（後期各模組開發完成後填入） -->
      <div class="module-grid">
        <div class="module-card disabled">
          <span class="icon">🍜</span>
          <span>菜單管理</span>
          <small>pos_menu（開發中）</small>
        </div>
        <div class="module-card disabled">
          <span class="icon">🧾</span>
          <span>訂單管理</span>
          <small>pos_order（待建立）</small>
        </div>
        <div class="module-card disabled">
          <span class="icon">👨‍🍳</span>
          <span>廚房顯示</span>
          <small>pos_kitchen（待建立）</small>
        </div>
        <div class="module-card disabled">
          <span class="icon">💳</span>
          <span>支付管理</span>
          <small>pos_payment（待建立）</small>
        </div>
        <div class="module-card disabled">
          <span class="icon">📊</span>
          <span>報表</span>
          <small>pos_report（待建立）</small>
        </div>
        <a href="/admin/" target="_blank" class="module-card">
          <span class="icon">⚙️</span>
          <span>Django Admin</span>
          <small>後台管理介面</small>
        </a>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'

const auth = useAuthStore()
const router = useRouter()

function handleLogout() {
  auth.logout()
  router.push('/')
}
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: #0f172a;
  color: white;
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: rgba(255, 255, 255, 0.05);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: white;
  font-size: 1.1rem;
  font-weight: 700;
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.welcome { color: #a0aec0; font-size: 0.9rem; }

.btn-outline {
  background: transparent;
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  padding: 0.4rem 1rem;
  border-radius: 8px;
  font-size: 0.9rem;
  cursor: pointer;
}
.btn-outline:hover { border-color: white; }

.content {
  padding: 2.5rem;
}
h2 {
  font-size: 1.75rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}
.hint {
  color: #718096;
  margin-bottom: 2rem;
  font-size: 0.9rem;
}

.module-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 1rem;
}

.module-card {
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 1.5rem 1rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  text-align: center;
  color: white;
  cursor: pointer;
  transition: background 0.2s;
}
.module-card:not(.disabled):hover {
  background: rgba(255, 255, 255, 0.12);
  border-color: #e94560;
}
.module-card.disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
.module-card .icon { font-size: 2rem; }
.module-card span { font-weight: 600; }
.module-card small { color: #718096; font-size: 0.75rem; }
</style>
