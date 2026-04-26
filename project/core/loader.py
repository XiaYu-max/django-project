"""
core/loader.py — 模組自動載入器

掃描 modules/ 下所有含 manifest.py 的目錄，依 depends 排序後：
  - 產生 INSTALLED_APPS 列表（給 settings.py 用）
  - 產生 urlpatterns 列表（給 config/urls.py 用）

完全依賴 Python 標準函式庫 + Django 內建機制，不引入任何第三方套件。
相容 Django 3.2 ~ 5.x。
"""

import importlib.util
from pathlib import Path

MODULES_DIR = Path(__file__).resolve().parent.parent / "modules"


def _load_manifest(module_name: str) -> dict:
    """讀取並回傳指定模組的 MANIFEST dict。"""
    manifest_path = MODULES_DIR / module_name / "manifest.py"
    spec = importlib.util.spec_from_file_location(
        f"_manifest_{module_name}", manifest_path
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.MANIFEST


def _topological_sort(manifests: dict) -> list:
    """依 depends 做拓樸排序，確保相依模組先載入。"""
    order = []
    visited = set()

    def visit(name):
        if name in visited:
            return
        visited.add(name)
        for dep in manifests.get(name, {}).get("depends", []):
            if dep in manifests:
                visit(dep)
        order.append(name)

    for name in sorted(manifests.keys()):
        visit(name)

    return order


def get_module_manifests() -> dict:
    """回傳 {module_name: MANIFEST} 字典，若 modules/ 不存在則回傳空字典。"""
    if not MODULES_DIR.exists():
        return {}

    manifests = {}
    for module_dir in sorted(MODULES_DIR.iterdir()):
        if module_dir.is_dir() and (module_dir / "manifest.py").exists():
            try:
                manifests[module_dir.name] = _load_manifest(module_dir.name)
            except Exception:
                pass  # 載入失敗時跳過，避免整個專案無法啟動
    return manifests


def get_installed_module_names() -> list:
    """回傳依賴排序後的模組名稱列表。"""
    manifests = get_module_manifests()
    return _topological_sort(manifests)


def get_module_apps() -> list:
    """回傳可放入 INSTALLED_APPS 的 Django app 路徑列表。"""
    return [f"modules.{name}" for name in get_installed_module_names()]


def get_api_urlpatterns() -> list:
    """
    回傳所有模組的 API urlpatterns。
    只在模組有 api/urls.py 時才掛載。
    路由格式：/api/<api_prefix>/
    """
    from django.urls import path, include

    manifests = get_module_manifests()
    module_names = _topological_sort(manifests)

    patterns = []
    for name in module_names:
        manifest = manifests.get(name, {})
        api_prefix = manifest.get("api_prefix", name)
        api_urls_path = MODULES_DIR / name / "api" / "urls.py"
        if api_urls_path.exists():
            patterns.append(
                path(f"api/{api_prefix}/", include(f"modules.{name}.api.urls"))
            )
    return patterns
