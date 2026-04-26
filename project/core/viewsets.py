"""
core/viewsets.py — 基礎 ViewSet

所有模組的 ViewSet 都繼承 BaseModelViewSet，自動獲得：
  - JWT 登入驗證（IsAuthenticated）
  - 模組權限比對（ModulePermission）
  - 標準分頁（StandardPagination）
  - 過濾 / 搜尋 / 排序（DRF 內建 filter_backends）

在子類別設定 required_permission 即可完成權限控管：
  class ItemViewSet(BaseModelViewSet):
      required_permission = "pos_menu.view_item"
      queryset = Item.objects.filter(is_active=True)
      serializer_class = ItemSerializer

相容 Django 3.2 ~ 5.x。
"""

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter

from .pagination import StandardPagination
from .permissions import ModulePermission


class BaseModelViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, ModulePermission]
    pagination_class = StandardPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]

    # 子類別覆寫此屬性來宣告所需權限，例如 'pos_menu.view_item'
    required_permission = None
