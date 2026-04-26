MANIFEST = {
    "name": "PosMenu",
    "version": "1.0.0",
    "description": "",
    "depends": ["base"],
    "models": True,
    "api_prefix": "pos-menu",
    "permissions": [
        "pos_menu.view_pos_menu",
        "pos_menu.change_pos_menu",
    ],
    "menu": [
        {
            "name": "PosMenu",
            "icon": "",
            "route": "/pos-menu",
            "permission": "pos_menu.view_pos_menu",
        }
    ],
}
