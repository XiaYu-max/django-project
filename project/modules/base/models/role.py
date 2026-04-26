from django.db import models
from core.models import BaseModel


class Role(BaseModel):
    """
    POS 角色定義。
    _name = 'base.role' → 資料表：base_role

    範例角色：
      code='cashier'   收銀員
      code='kitchen'   廚房人員
      code='manager'   店長
      code='admin'     系統管理員
    """
    _name = 'base.role'

    name = models.CharField(max_length=100, unique=True, verbose_name='角色名稱')
    code = models.CharField(max_length=50, unique=True, verbose_name='代碼')
    description = models.TextField(blank=True, verbose_name='說明')
    permissions = models.ManyToManyField(
        'auth.Permission',
        blank=True,
        related_name='roles',
        verbose_name='Django 權限',
    )

    def __str__(self):
        return f'{self.name} ({self.code})'

    class Meta:
        verbose_name = '角色'
        verbose_name_plural = '角色'
