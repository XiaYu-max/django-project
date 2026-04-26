# POS 點餐平台

仿 Odoo 模組化架構的餐廳 POS 系統，前後端分離，支援多角色權限管理。

## 技術棧

| 層級 | 技術 |
|------|------|
| 後端 | Django 5.x + Django REST Framework + SimpleJWT |
| 前端 | Vue 3 + Vite + Pinia + Vue Router 4 + TypeScript |
| 資料庫 | PostgreSQL 15 |
| 反向代理 | nginx（port 80 統一入口） |
| 開發環境 | Vagrant + Ubuntu 22.04 + Docker Compose |

---

## 專案結構

```
django-project/
├── Vagrantfile              # 開發 VM 設定（Ubuntu 22.04）
├── bootstrap.sh             # Vagrant 初始化腳本（自動裝 Docker）
├── scripts/
│   ├── dev/                 # 本地開發用腳本（.bat）與說明
│   └── cloud/               # 雲端部署用腳本（setup.sh）與說明
└── project/                 # Django 專案根目錄
    ├── docker-compose.yml   # 四個容器：db / web / frontend / nginx
    ├── nginx.conf           # 反向代理設定
    ├── config/              # Django 設定、root URLs
    ├── core/                # 框架基礎設施（loader、BaseModel、BaseViewSet…）
    ├── modules/             # 業務模組
    │   ├── base/            # 使用者、角色、權限（必要基礎模組）
    │   └── pos_menu/        # 菜單模組（開發中）
    └── frontend/            # Vue 3 前端
        └── src/
            ├── core/        # 共用 axios client、共用 views
            ├── modules/     # 各模組的 views / api.ts
            ├── stores/      # Pinia（auth）
            └── router/      # Vue Router
```

---

## 架構設計

所有請求都進 **nginx port 80**，由 nginx 分流：

```
http://localhost/          → Vue 3（Vite, 5173）
http://localhost/api/…     → Django（8000）
http://localhost/admin/    → Django Admin
http://localhost/static/   → Django static files
```

新增功能 = 新增模組。每個模組有獨立的 `manifest.py` 宣告，`core/loader.py` 自動掃描並掛載 API 路由，不需手動修改 `config/urls.py`。

---

## 本地開發環境建置（Windows，只需做一次）

### 步驟一：安裝必要工具

1. **Git**：https://git-scm.com/download/win
2. **VirtualBox 7.x**：https://www.virtualbox.org/wiki/Downloads
3. **Vagrant 2.4.x**：https://developer.hashicorp.com/vagrant/downloads
4. **VS Code**：https://code.visualstudio.com/

安裝完後，開一個新的 PowerShell 確認：

```powershell
git --version
vagrant --version
```

### 步驟二：VS Code 建議安裝的 Extension

- **Remote - SSH**（`ms-vscode-remote.remote-ssh`）— SSH 進 VM 開發
- **Python**（`ms-python.python`）— Django 語法支援
- **Vue - Official**（`Vue.volar`）— Vue 3 語法支援
- **Thunder Client**（`rangav.vscode-thunder-client`）— API 測試（可選）

### 步驟三：取得程式碼

```powershell
git clone <your-repo-url>
cd django-project
```

### 步驟四：啟動 VM（第一次約需 5-10 分鐘）

```powershell
vagrant up
```

`bootstrap.sh` 會自動在 VM 裡安裝 Docker 與 Docker Compose。

> 如果出現 VirtualBox 的 UAC 彈窗，請允許。

### 步驟五：啟動 Docker 容器

```powershell
ssh default "cd /home/vagrant/project && docker compose up -d"
```

等待約 1-2 分鐘讓 pip install 完成，再確認四個容器都是 `Up`：

```powershell
ssh default "cd /home/vagrant/project && docker compose ps"
```

### 步驟六：套用資料庫 Migration

在 VS Code 按 `Ctrl+Shift+B`，選擇 **Django: migrate（全部）**

### 步驟七：建立後台管理員帳號

```powershell
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py createsuperuser"
```

### 步驟八：開啟瀏覽器

| 網址 | 說明 |
|------|------|
| http://localhost/ | 首頁 |
| http://localhost/login | 員工登入 |
| http://localhost/dashboard | 管理後台（需登入）|
| http://localhost/admin/ | Django Admin |

---

## 雲端部署（Linux，只需做一次）

### 步驟一：安裝 Docker

```bash
curl -fsSL https://get.docker.com | bash
sudo usermod -aG docker $USER
newgrp docker
```

### 步驟二：取得程式碼並執行部署腳本

```bash
git clone <your-repo-url>
cd django-project
bash scripts/cloud/setup.sh
```

腳本會自動啟動容器並等待 Django 就緒後執行 migrate。

### 步驟三：建立後台管理員

```bash
cd project
docker compose exec web python manage.py createsuperuser
```

開啟瀏覽器：**http://your-server-ip/**

---

## 日常開發操作（VS Code）

按 `Ctrl+Shift+B` 選擇任務：

| 任務 | 說明 |
|------|------|
| `Django: migrate（全部）` | 套用所有 migration（**預設任務**）|
| `Django: makemigrations（指定模組）` | 建立指定模組的 migration |
| `Django: migrate（指定模組）` | 只 migrate 指定模組 |
| `Django: startmodule（建立新模組）` | 建立新業務模組骨架 |
| `Django: createsuperuser` | 建立後台管理員 |
| `Django: restart（重啟容器）` | 重啟所有容器 |
| `Django: recreate（重建容器）` | 強制重建所有容器 |
| `Django Logs` | 即時查看 Django log |

---

## 新增業務模組

```bash
# 1. 建立模組骨架（VS Code）
# Ctrl+Shift+B → Django: startmodule → 輸入模組名稱（例如 pos_order）

# 2. 編輯 modules/pos_order/manifest.py（填入名稱、api_prefix、permissions）
# 3. 建立 models/、api/（serializers、viewsets、urls）

# 4. 執行 migration
# Ctrl+Shift+B → Django: makemigrations → pos_order
# Ctrl+Shift+B → Django: migrate → pos_order

# 5. 建立前端視圖（frontend/src/modules/pos_order/views/）
# 6. 建立 frontend/src/modules/pos_order/api.ts
# 7. 在 router/index.ts 新增路由
# 8. 在 DashboardView.vue 的 modules 陣列設 ready: true
```

---

## 分支策略

```
master   → 穩定版本
dev      → 開發整合
feature/ → 單一功能開發，完成後 PR 合回 dev
```

每個 PR 只動一個模組。


