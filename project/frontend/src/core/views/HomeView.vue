<template>
  <div class="page">
    <!-- 頂部導覽列 -->
    <nav class="navbar">
      <div class="brand">
        <span class="brand-icon">🍽</span>
        <span class="brand-name">POS 點餐系統</span>
      </div>
      <div class="nav-actions">
        <template v-if="auth.isLoggedIn">
          <span class="welcome">{{ auth.username }}</span>
          <RouterLink to="/dashboard" class="btn-primary">管理後台</RouterLink>
          <button @click="handleLogout" class="btn-outline">登出</button>
        </template>
        <RouterLink v-else to="/login" class="btn-primary">登入</RouterLink>
      </div>
    </nav>

    <!-- 主畫面 -->
    <main class="hero">
      <div class="hero-content">
        <h1 class="hero-title">歡迎光臨</h1>
        <p class="hero-subtitle">掃描桌上的 QR Code，或點擊下方按鈕開始點餐</p>
        <RouterLink to="/order" class="btn-order">開始點餐</RouterLink>
        <p class="hero-hint">員工 / 管理者請點右上角「登入」</p>
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
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  color: white;
}

/* ── Navbar ───────────────────────────────────── */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.brand {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.25rem;
  font-weight: 700;
}
.brand-icon { font-size: 1.5rem; }

.nav-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.welcome {
  color: #a0aec0;
  font-size: 0.9rem;
}

.btn-primary {
  background: #e94560;
  color: white;
  border: none;
  padding: 0.5rem 1.25rem;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}
.btn-primary:hover { background: #c73652; }

.btn-outline {
  background: transparent;
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  padding: 0.5rem 1.25rem;
  border-radius: 8px;
  font-size: 0.95rem;
  cursor: pointer;
  transition: border-color 0.2s;
}
.btn-outline:hover { border-color: white; }

/* ── Hero ─────────────────────────────────────── */
.hero {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 65px);
}

.hero-content {
  text-align: center;
  padding: 2rem;
}

.hero-title {
  font-size: 4rem;
  font-weight: 900;
  margin-bottom: 1rem;
  letter-spacing: 0.08em;
}

.hero-subtitle {
  font-size: 1.1rem;
  color: #a0aec0;
  margin-bottom: 2.5rem;
}

.btn-order {
  display: inline-block;
  background: linear-gradient(135deg, #e94560, #c73652);
  color: white;
  padding: 1rem 3.5rem;
  border-radius: 50px;
  font-size: 1.4rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  box-shadow: 0 8px 32px rgba(233, 69, 96, 0.4);
  transition: transform 0.2s, box-shadow 0.2s;
}
.btn-order:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 40px rgba(233, 69, 96, 0.6);
}

.hero-hint {
  margin-top: 2rem;
  color: #4a5568;
  font-size: 0.85rem;
}
</style>
