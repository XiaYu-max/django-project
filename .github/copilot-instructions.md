# Copilot 開發守則 — POS 點餐平台

## 專案概述

- **後端**：Django 5.x + Django REST Framework (DRF)
- **前端**：Vue 3 + Vite
- **資料庫**：PostgreSQL
- **目標**：仿 Odoo 模組化架構的 POS 點餐平台，支援多角色、多模組、自動化權限與 API 註冊

---

## 模組化架構

### 目錄結構

```
project/
  config/               # Django 設定、root urls
  modules/              # 所有業務模組放這裡
    base/               # 核心基礎模組（必須存在）
    pos_menu/           # 菜單模組
    pos_order/          # 訂單模組
    pos_kitchen/        # 廚房模組
    pos_payment/        # 支付模組
    pos_report/         # 報表模組
    ...
  core/                 # 框架基礎設施（模組載入器、base model、base viewset）
```

### 每個模組的標準結構

```
modules/pos_menu/
  __init__.py
  manifest.py           # 模組宣告（唯一必要入口）
  models/
    __init__.py
    category.py
    item.py
  api/
    __init__.py
    serializers.py
    viewsets.py
    urls.py             # router.register() 在這裡
  permissions/
    __init__.py
    rules.py            # 自定義 DRF Permission class
  admin.py
  apps.py
```

---

## manifest.py 規範

每個模組都必須有 `manifest.py`，這是模組的唯一入口宣告。

```python
# modules/pos_menu/manifest.py

MANIFEST = {
    "name": "POS Menu",
    "version": "1.0.0",
    "description": "菜單與分類管理",
    "depends": ["base"],          # 依賴的其他模組名稱
    "models": True,               # 是否有 models 需要 migrate
    "api_prefix": "menu",         # API 路由前綴：/api/menu/
    "permissions": [              # 此模組定義的權限代號
        "pos_menu.view_category",
        "pos_menu.edit_category",
        "pos_menu.view_item",
        "pos_menu.edit_item",
    ],
    "menu": [                     # 前端側邊選單
        {
            "name": "菜單管理",
            "icon": "menu-book",
            "route": "/menu",
            "permission": "pos_menu.view_item",
            "children": [
                {"name": "分類設定", "route": "/menu/category", "permission": "pos_menu.view_category"},
                {"name": "品項設定", "route": "/menu/item",     "permission": "pos_menu.view_item"},
            ],
        }
    ],
}
```

---

## core/ 框架基礎設施

### core/loader.py — 模組自動載入

- 掃描 `modules/` 下所有模組的 `manifest.py`
- 依照 `depends` 排序載入順序
- 自動將模組加入 `INSTALLED_APPS`
- 自動收集各模組 `api/urls.py` 並掛載到 `/api/<api_prefix>/`

### core/models.py — 基礎 Model

```python
# 所有模組的 Model 都繼承這個
# _name = 'module.resource' 自動決定資料表名稱（點換底線）
class BaseModel(models.Model):
    _name = None  # 例如 'pos.menu.item' → 資料表 pos_menu_item

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        abstract = True
```

### core/viewsets.py — 基礎 ViewSet

```python
# 所有模組的 ViewSet 都繼承這個，已內建分頁、過濾、軟刪除
class BaseModelViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, ModulePermission]
    pagination_class = StandardPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
```

### core/permissions.py — 模組權限

```python
# 根據 manifest 宣告的 permissions 自動比對 request.user
class ModulePermission(BasePermission):
    def has_permission(self, request, view):
        required = getattr(view, 'required_permission', None)
        if not required:
            return True
        return request.user.has_perm(required)
```

---

## API 設計規範

### 風格

- 統一使用 DRF `ModelViewSet` + `DefaultRouter`
- URL 格式：`/api/<module_prefix>/<resource>/`
- 回應格式統一：

```json
{
  "success": true,
  "data": { ... },
  "message": "",
  "pagination": { "total": 100, "page": 1, "page_size": 20 }
}
```

### 在模組內建立 API（標準流程）

1. `models/item.py` → 定義 Model（繼承 BaseModel）
2. `api/serializers.py` → 定義 Serializer
3. `api/viewsets.py` → 定義 ViewSet（繼承 BaseModelViewSet），設定 `required_permission`
4. `api/urls.py` → `router.register()`，結束，不用動 `config/urls.py`

```python
# api/urls.py
from rest_framework.routers import DefaultRouter
from .viewsets import CategoryViewSet, ItemViewSet

router = DefaultRouter()
router.register("categories", CategoryViewSet)
router.register("items", ItemViewSet)

urlpatterns = router.urls
```

---

## 前端 Vue 規範

### 目錄結構

```
frontend/
  src/
    modules/            # 對應後端模組
      pos_menu/
        api.js          # 封裝此模組所有 API 呼叫
        views/
          CategoryList.vue
          ItemForm.vue
        components/
        store/          # Pinia store
    core/
      api/
        client.js       # axios 實例，統一 baseURL、token、錯誤處理
      router/
        index.js        # 根據 manifest menu 動態產生路由
      store/
        auth.js
```

### API 呼叫規範

所有 API 呼叫都透過各模組的 `api.js`，不直接在 component 裡 fetch：

```js
// modules/pos_menu/api.js
import client from '@/core/api/client'

export const menuApi = {
  getItems: (params) => client.get('/api/menu/items/', { params }),
  createItem: (data) => client.post('/api/menu/items/', data),
  updateItem: (id, data) => client.put(`/api/menu/items/${id}/`, data),
  deleteItem: (id) => client.delete(`/api/menu/items/${id}/`),
}
```

---

## 權限設計

- 權限代號格式：`<module_name>.<action>_<resource>`，例如 `pos_menu.edit_item`
- 角色（Role）與權限（Permission）為多對多關係，定義在 `base` 模組
- 前端根據 token 內的 permissions 陣列控制 UI 顯示
- 後端每個 ViewSet 宣告 `required_permission`，由 `ModulePermission` 自動比對

---

## 開發守則

1. **新增功能 = 新增模組**，不修改既有模組的底層，只透過 `depends` 擴充
2. **不允許**在 `config/urls.py` 手動加路由，所有 API 由 loader 自動掛載
3. **不允許**在 view/component 直接寫 SQL 或 ORM 查詢，邏輯放在 model 或 service layer
4. **所有 Model** 必須繼承 `BaseModel`，擁有 `created_at`、`updated_at`、`is_active`
5. **API 回應**統一用 `core` 提供的 Response wrapper，不自行包格式
6. **前端 API 呼叫**統一走各模組 `api.js`，不在 component 直接呼叫 axios
7. **權限**由 manifest 宣告後自動建立，不手動在 admin 建立
8. 每個 PR 只動一個模組，跨模組需拆分

---

## 環境資訊

- Python 3.11 / Django 5.x
- PostgreSQL 15
- Docker Compose（開發環境）
- DRF + `djangorestframework-simplejwt` 做 JWT 認證
- Vue 3 + Vite + Pinia + Vue Router 4
- 程式語言：後端 Python，前端 TypeScript（優先）或 JavaScript
