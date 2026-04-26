MANIFEST = {
    "name": "Base",
    "version": "1.0.0",
    "description": "使用者、角色與權限管理（核心基礎模組，所有模組都依賴它）",
    "depends": [],
    "models": True,
    "api_prefix": "base",
    "permissions": [
        "base.view_role",
        "base.change_role",
        "base.view_userprofile",
        "base.change_userprofile",
    ],
    "menu": [
        {
            "name": "系統設定",
            "icon": "settings",
            "route": "/settings",
            "permission": "base.view_role",
            "children": [
                {"name": "角色管理", "route": "/settings/roles",   "permission": "base.view_role"},
                {"name": "使用者管理", "route": "/settings/users", "permission": "base.view_userprofile"},
            ],
        }
    ],
}
