"""
URL configuration for config project.

規則：
  - 不在這裡手動新增模組路由
  - 模組 API 路由由 core.loader.get_api_urlpatterns() 自動掛載
  - 路由格式：/api/<manifest api_prefix>/<resource>/
"""

from django.contrib import admin
from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from core.loader import get_api_urlpatterns


urlpatterns = [
    path('admin/', admin.site.urls),

    # JWT 登入：POST /api/auth/token/        → 取得 access + refresh token
    # JWT 刷新：POST /api/auth/token/refresh/ → 用 refresh token 換新 access token
    path('api/auth/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # 各模組 API（從 manifest.py 的 api_prefix 自動掛載）
    *get_api_urlpatterns(),
]
