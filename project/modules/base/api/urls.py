from rest_framework.routers import DefaultRouter
from .viewsets import RoleViewSet, UserProfileViewSet

router = DefaultRouter()
router.register('roles', RoleViewSet)
router.register('users', UserProfileViewSet)

urlpatterns = router.urls
