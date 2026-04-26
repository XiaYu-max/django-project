<template>
  <div class="page">
    <nav class="navbar">
      <RouterLink to="/" class="brand">
        <span>🍽</span>
        <span>POS 點餐系統</span>
      </RouterLink>
      <RouterLink to="/login" class="btn-staff">員工登入</RouterLink>
    </nav>

    <main class="content">
      <div class="placeholder">
        <span class="icon">🍜</span>
        <h2>菜單載入中...</h2>
        <p>pos_menu 模組開發完成後，這裡將顯示可點餐的菜單</p>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
// pos_menu 模組開發後，在此引入 menuApi 並載入菜單資料
</script>

<style scoped>
.page {
  min-height: 100vh;
  background: #fafafa;
  color: #1a202c;
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: white;
  border-bottom: 1px solid #e2e8f0;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: #1a202c;
  font-size: 1.1rem;
  font-weight: 700;
}

.btn-staff {
  color: #718096;
  font-size: 0.85rem;
  border: 1px solid #e2e8f0;
  padding: 0.4rem 0.9rem;
  border-radius: 8px;
  transition: color 0.2s;
}
.btn-staff:hover { color: #e94560; border-color: #e94560; }

.content {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 65px);
}

.placeholder {
  text-align: center;
  color: #a0aec0;
}
.placeholder .icon { font-size: 4rem; display: block; margin-bottom: 1rem; }
.placeholder h2 { font-size: 1.5rem; margin-bottom: 0.5rem; color: #718096; }
.placeholder p { font-size: 0.9rem; }
</style>
