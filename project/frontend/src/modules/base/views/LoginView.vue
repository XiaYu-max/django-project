<template>
  <div class="page">
    <nav class="navbar">
      <RouterLink to="/" class="brand">
        <span>🍽</span>
        <span>POS 點餐系統</span>
      </RouterLink>
    </nav>

    <main class="login-area">
      <div class="login-card">
        <h2>員工登入</h2>
        <p class="subtitle">請輸入您的帳號密碼</p>

        <form @submit.prevent="handleLogin">
          <div class="field">
            <label for="username">帳號</label>
            <input
              id="username"
              v-model="form.username"
              type="text"
              placeholder="Username"
              autocomplete="username"
              required
            />
          </div>
          <div class="field">
            <label for="password">密碼</label>
            <input
              id="password"
              v-model="form.password"
              type="password"
              placeholder="Password"
              autocomplete="current-password"
              required
            />
          </div>

          <p v-if="error" class="error">{{ error }}</p>

          <button type="submit" class="btn-submit" :disabled="loading">
            {{ loading ? '登入中...' : '登入' }}
          </button>
        </form>

        <RouterLink to="/" class="back-link">← 返回首頁</RouterLink>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const auth = useAuthStore()

const form = ref({ username: '', password: '' })
const loading = ref(false)
const error = ref('')

async function handleLogin() {
  loading.value = true
  error.value = ''
  try {
    await auth.login(form.value.username, form.value.password)
    router.push('/dashboard')
  } catch {
    error.value = '帳號或密碼錯誤，請再試一次'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  color: white;
}

.navbar {
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

.login-area {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 57px);
}

.login-card {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 16px;
  padding: 2.5rem;
  width: 100%;
  max-width: 400px;
}

h2 {
  font-size: 1.75rem;
  font-weight: 700;
  margin-bottom: 0.4rem;
}

.subtitle {
  color: #a0aec0;
  font-size: 0.9rem;
  margin-bottom: 2rem;
}

.field {
  margin-bottom: 1.25rem;
}
.field label {
  display: block;
  font-size: 0.85rem;
  color: #a0aec0;
  margin-bottom: 0.4rem;
}
.field input {
  width: 100%;
  background: rgba(255, 255, 255, 0.07);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  color: white;
  padding: 0.75rem 1rem;
  font-size: 1rem;
  outline: none;
  transition: border-color 0.2s;
}
.field input:focus { border-color: #e94560; }
.field input::placeholder { color: #4a5568; }

.error {
  color: #fc8181;
  font-size: 0.85rem;
  margin-bottom: 1rem;
}

.btn-submit {
  width: 100%;
  background: #e94560;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 0.875rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
  margin-top: 0.25rem;
}
.btn-submit:hover:not(:disabled) { background: #c73652; }
.btn-submit:disabled { opacity: 0.6; cursor: not-allowed; }

.back-link {
  display: block;
  text-align: center;
  margin-top: 1.5rem;
  color: #718096;
  font-size: 0.9rem;
  transition: color 0.2s;
}
.back-link:hover { color: #a0aec0; }
</style>
