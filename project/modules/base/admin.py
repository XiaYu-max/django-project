from django.contrib import admin
from .models.role import Role
from .models.user_profile import UserProfile


@admin.register(Role)
class RoleAdmin(admin.ModelAdmin):
    list_display = ['name', 'code', 'is_active', 'created_at']
    search_fields = ['name', 'code']
    filter_horizontal = ['permissions']


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'display_name', 'phone', 'is_active', 'created_at']
    search_fields = ['user__username', 'display_name', 'phone']
    filter_horizontal = ['roles']
