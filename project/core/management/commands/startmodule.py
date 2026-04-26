"""
Django management command — 自動建立新模組骨架

用法：
  python manage.py startmodule <module_name> [--prefix <api_prefix>]

範例：
  python manage.py startmodule pos_menu
  python manage.py startmodule pos_order --prefix orders

產生的結構：
  modules/<module_name>/
    __init__.py
    apps.py
    manifest.py
    admin.py
    migrations/
      __init__.py
    models/
      __init__.py
    api/
      __init__.py
      serializers.py
      viewsets.py
      urls.py
"""

import os
from pathlib import Path
from django.core.management.base import BaseCommand, CommandError


class Command(BaseCommand):
    help = '建立新模組骨架（仿 Odoo 模組結構）'

    def add_arguments(self, parser):
        parser.add_argument('module_name', type=str, help='模組名稱，例如 pos_menu')
        parser.add_argument(
            '--prefix',
            type=str,
            default='',
            help='API 路由前綴，預設與模組名相同（底線換短橫線），例如 --prefix menu',
        )

    def handle(self, *args, **options):
        module_name = options['module_name'].lower().replace('-', '_')
        api_prefix = options['prefix'] or module_name.replace('_', '-')

        # 模組目錄
        modules_dir = Path(__file__).resolve().parent.parent.parent.parent / 'modules'
        target = modules_dir / module_name

        if target.exists():
            raise CommandError(f'模組 "{module_name}" 已存在：{target}')

        # 建立目錄
        dirs = [
            target,
            target / 'models',
            target / 'api',
            target / 'migrations',
        ]
        for d in dirs:
            d.mkdir(parents=True, exist_ok=True)

        # 產生各檔案
        files = self._get_files(module_name, api_prefix)
        for rel_path, content in files.items():
            file_path = target / rel_path
            file_path.write_text(content, encoding='utf-8')
            self.stdout.write(f'  建立  {file_path.relative_to(modules_dir.parent)}')

        self.stdout.write(self.style.SUCCESS(
            f'\n模組 "{module_name}" 建立完成！\n'
            f'接下來：\n'
            f'  1. 編輯 modules/{module_name}/models/ 加入欄位\n'
            f'  2. 編輯 modules/{module_name}/api/serializers.py\n'
            f'  3. python manage.py makemigrations {module_name}\n'
            f'  4. python manage.py migrate\n'
        ))

    def _get_files(self, module_name: str, api_prefix: str) -> dict:
        label = module_name
        class_prefix = ''.join(word.capitalize() for word in module_name.split('_'))

        return {
            '__init__.py': (
                f"default_app_config = 'modules.{module_name}.apps.{class_prefix}Config'\n"
            ),

            'apps.py': (
                f"from django.apps import AppConfig\n\n\n"
                f"class {class_prefix}Config(AppConfig):\n"
                f"    name = 'modules.{module_name}'\n"
                f"    label = '{label}'\n"
                f"    verbose_name = '{class_prefix}'\n"
            ),

            'manifest.py': (
                f"MANIFEST = {{\n"
                f'    "name": "{class_prefix}",\n'
                f'    "version": "1.0.0",\n'
                f'    "description": "",\n'
                f'    "depends": ["base"],\n'
                f'    "models": True,\n'
                f'    "api_prefix": "{api_prefix}",\n'
                f'    "permissions": [\n'
                f'        "{module_name}.view_{module_name}",\n'
                f'        "{module_name}.change_{module_name}",\n'
                f'    ],\n'
                f'    "menu": [\n'
                f'        {{\n'
                f'            "name": "{class_prefix}",\n'
                f'            "icon": "",\n'
                f'            "route": "/{api_prefix}",\n'
                f'            "permission": "{module_name}.view_{module_name}",\n'
                f'        }}\n'
                f'    ],\n'
                f"}}\n"
            ),

            'admin.py': (
                f"from django.contrib import admin\n"
                f"# from .models.example import Example\n\n"
                f"# @admin.register(Example)\n"
                f"# class ExampleAdmin(admin.ModelAdmin):\n"
                f"#     list_display = ['id', 'is_active', 'created_at']\n"
            ),

            'migrations/__init__.py': '',

            'models/__init__.py': (
                f"# from .example import Example\n"
                f"# __all__ = ['Example']\n"
            ),

            'api/__init__.py': '',

            'api/serializers.py': (
                f"from rest_framework import serializers\n"
                f"# from ..models.example import Example\n\n\n"
                f"# class ExampleSerializer(serializers.ModelSerializer):\n"
                f"#     class Meta:\n"
                f"#         model = Example\n"
                f"#         fields = '__all__'\n"
                f"#         read_only_fields = ['created_at', 'updated_at']\n"
            ),

            'api/viewsets.py': (
                f"from core.viewsets import BaseModelViewSet\n"
                f"# from ..models.example import Example\n"
                f"# from .serializers import ExampleSerializer\n\n\n"
                f"# class ExampleViewSet(BaseModelViewSet):\n"
                f"#     required_permission = '{module_name}.view_example'\n"
                f"#     queryset = Example.objects.filter(is_active=True)\n"
                f"#     serializer_class = ExampleSerializer\n"
            ),

            'api/urls.py': (
                f"from rest_framework.routers import DefaultRouter\n"
                f"# from .viewsets import ExampleViewSet\n\n"
                f"router = DefaultRouter()\n"
                f"# router.register('examples', ExampleViewSet)\n\n"
                f"urlpatterns = router.urls\n"
            ),
        }
