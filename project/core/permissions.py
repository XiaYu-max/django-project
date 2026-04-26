"""
core/permissions.py — 模組權限

ModulePermission：
  讀取 ViewSet 上宣告的 required_permission，
  呼叫 Django 內建 user.has_perm() 比對。

  - 若 ViewSet 未設定 required_permission → 只驗證登入
  - 若有設定 → 同時驗證登入 + 擁有該權限

完全使用 Django 內建權限系統，不自行造輪子。
相容 Django 3.2 ~ 5.x。
"""

from rest_framework.permissions import BasePermission


class ModulePermission(BasePermission):
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False

        required = getattr(view, "required_permission", None)
        if not required:
            return True

        return request.user.has_perm(required)
