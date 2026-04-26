from django.db import models
from django.contrib.auth import get_user_model
from core.models import BaseModel
from .role import Role


class UserProfile(BaseModel):
    """
    使用者擴充資料（延伸 Django 內建 auth_user）。
    _name = 'base.user.profile' → 資料表：base_user_profile

    不修改 AUTH_USER_MODEL，透過 OneToOneField 延伸。
    登入 / 密碼由 Django auth_user 管理，
    POS 資料（角色、顯示名稱）由此表管理。
    """
    _name = 'base.user.profile'

    user = models.OneToOneField(
        get_user_model(),
        on_delete=models.CASCADE,
        related_name='profile',
        verbose_name='帳號',
    )
    display_name = models.CharField(max_length=100, blank=True, verbose_name='顯示名稱')
    phone = models.CharField(max_length=20, blank=True, verbose_name='電話')
    roles = models.ManyToManyField(
        Role,
        blank=True,
        related_name='user_profiles',
        verbose_name='角色',
    )

    def __str__(self):
        return self.display_name or self.user.username

    class Meta:
        verbose_name = '使用者資料'
        verbose_name_plural = '使用者資料'
