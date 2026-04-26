"""
core/pagination.py — 標準分頁

統一 API 回應格式：
{
    "success": true,
    "data": [...],
    "message": "",
    "pagination": {
        "total": 100,
        "page": 1,
        "page_size": 20,
        "pages": 5
    }
}

繼承 DRF 的 PageNumberPagination，完全在 DRF 框架內運作。
相容 Django 3.2 ~ 5.x。
"""

from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response


class StandardPagination(PageNumberPagination):
    page_size = 20
    page_size_query_param = "page_size"
    max_page_size = 100

    def get_paginated_response(self, data):
        return Response(
            {
                "success": True,
                "data": data,
                "message": "",
                "pagination": {
                    "total": self.page.paginator.count,
                    "page": self.page.number,
                    "page_size": self.get_page_size(self.request),
                    "pages": self.page.paginator.num_pages,
                },
            }
        )

    def get_paginated_response_schema(self, schema):
        return {
            "type": "object",
            "properties": {
                "success": {"type": "boolean"},
                "data": schema,
                "message": {"type": "string"},
                "pagination": {
                    "type": "object",
                    "properties": {
                        "total": {"type": "integer"},
                        "page": {"type": "integer"},
                        "page_size": {"type": "integer"},
                        "pages": {"type": "integer"},
                    },
                },
            },
        }
