"""
core/models.py — 基礎 Model

仿 Odoo 的 _name 機制：
  在 Model 宣告 _name = 'module.resource'
  資料表名稱自動變成 module_resource（點換底線）

範例：
  class Item(BaseModel):
      _name = 'pos.menu.item'   →   資料表：pos_menu_item
      name = models.CharField(max_length=100)

同時自動具備：
  - created_at：建立時間
  - updated_at：最後更新時間
  - is_active：軟刪除旗標

相容 Django 3.2 ~ 5.x。
"""

from django.db import models
from django.db.models.base import ModelBase


class PosModelBase(ModelBase):
    """
    自訂 metaclass。
    當 Model 有宣告 _name 時，自動將 Meta.db_table 設為 _name 將點換底線的結果。
    沒有宣告 _name 則沿用 Django 預設命名規則。
    """

    def __new__(mcs, name, bases, namespace, **kwargs):
        _name = namespace.get('_name')
        if _name:
            meta = namespace.get('Meta')
            if meta is None:
                meta = type('Meta', (), {})
                namespace['Meta'] = meta
            if not hasattr(meta, 'db_table'):
                meta.db_table = _name.replace('.', '_')
        return super().__new__(mcs, name, bases, namespace, **kwargs)


class BaseModel(models.Model, metaclass=PosModelBase):
    _name = None  # 子類別覆寫，例如 _name = 'pos.menu.item'

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        abstract = True
