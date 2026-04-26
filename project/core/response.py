"""
core/response.py — API 回應包裝器

提供兩個 helper function，統一所有 API 的回應格式，
ViewSet 和 view 直接呼叫，不需要自行組裝 dict。

成功回應：
{
    "success": true,
    "data": { ... },
    "message": ""
}

失敗回應：
{
    "success": false,
    "data": null,
    "message": "錯誤說明",
    "errors": { ... }
}
"""

from rest_framework.response import Response


def success_response(data=None, message="", status=200):
    return Response(
        {
            "success": True,
            "data": data,
            "message": message,
        },
        status=status,
    )


def error_response(message="", errors=None, status=400):
    return Response(
        {
            "success": False,
            "data": None,
            "message": message,
            "errors": errors,
        },
        status=status,
    )
