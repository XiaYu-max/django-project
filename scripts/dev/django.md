# Django POS 專案指令手冊

所有指令都在 **VM 內的容器**執行。  
在 Windows 上透過 `ssh default` 送進去：

```
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py <指令>"
```

或先 SSH 進 VM，再進容器 shell：
```
vagrant ssh
cd /home/vagrant/project
docker compose exec web bash
# 之後就可以直接打 python manage.py ...
```

---

## 模組

### 建立新模組骨架
```bash
python manage.py startmodule <module_name>
python manage.py startmodule <module_name> --prefix <api_prefix>
```
範例：
```bash
python manage.py startmodule pos_order
python manage.py startmodule pos_kitchen --prefix kitchen
```
產生：`modules/<module_name>/` 完整骨架（manifest、models、api、migrations）

---

## 資料庫

### 偵測 Model 變更，產生 migration 檔
```bash
python manage.py makemigrations
python manage.py makemigrations <module_name>   # 只產生指定模組
```

### 套用 migration 到資料庫
```bash
python manage.py migrate
python manage.py migrate <module_name>          # 只套用指定模組
```

### 查看 migration 狀態
```bash
python manage.py showmigrations                 # 全部模組
python manage.py showmigrations <module_name>   # 指定模組
```

### 倒回 migration（開發中才用，上線後不要）
```bash
python manage.py migrate <module_name> zero     # 倒回該模組全部
python manage.py migrate <module_name> 0001     # 倒回到指定版本
```

---

## 使用者

### 建立後台管理員帳號
```bash
python manage.py createsuperuser
```

### 修改使用者密碼
```bash
python manage.py changepassword <username>
```

---

## 伺服器

### 啟動開發伺服器
```bash
python manage.py runserver 0.0.0.0:8000
```
> Docker 容器已自動啟動，通常不需要手動跑

### 查看所有可用 URL 路由
```bash
python manage.py show_urls     # 需安裝 django-extensions
```
> 目前可改用 http://localhost:8000/api/ 瀏覽 DRF 自動產生的 API 頁面

---

## 除錯 / 檢查

### 檢查設定是否有問題
```bash
python manage.py check
```

### 開啟 Django Shell（可直接操作 Model）
```bash
python manage.py shell

# Shell 內範例：
from modules.base.models.role import Role
Role.objects.all()
Role.objects.create(name='收銀員', code='cashier')
```

### 查看某張資料表的 SQL 結構
```bash
python manage.py sqlmigrate <module_name> 0001
```

---

## Docker 容器管理（在 VM 內執行）

```bash
docker compose up -d          # 啟動所有容器
docker compose down           # 停止所有容器
docker compose restart web    # 重啟 Django（改 settings.py 後用）
docker compose logs -f web    # 即時查看 Django log
docker compose ps             # 查看容器狀態
```

### 進入容器 shell
```bash
docker compose exec web bash  # Django 容器
docker compose exec db bash   # PostgreSQL 容器
```

### 進入 PostgreSQL
```bash
docker compose exec db psql -U django -d django

# psql 內常用指令：
\dt             # 列出所有資料表
\d <table>      # 查看資料表結構
\q              # 離開
```

---

## 在 Windows 上一鍵執行（透過 VS Code）

| 操作 | 方式 |
|------|------|
| makemigrations + migrate | `Ctrl+Shift+B` → 選 1 |
| 重啟 Django 容器 | `Ctrl+Shift+B` → 選 2 |
| 重建容器 | `Ctrl+Shift+B` → 選 3 |

---

## API 端點（開發中可用瀏覽器測試）

| 端點 | 說明 |
|------|------|
| `POST /api/auth/token/` | 登入，取得 access + refresh token |
| `POST /api/auth/token/refresh/` | 用 refresh token 換新 access token |
| `GET  /api/base/roles/` | 角色列表 |
| `GET  /api/base/users/` | 使用者列表 |
| `GET  /api/<prefix>/<resource>/` | 各模組 API（依 manifest api_prefix） |
