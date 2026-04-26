from core.viewsets import BaseModelViewSet
from core.response import success_response
from ..models.role import Role
from ..models.user_profile import UserProfile
from .serializers import RoleSerializer, UserProfileSerializer, UserCreateSerializer


class RoleViewSet(BaseModelViewSet):
    required_permission = 'base.view_role'
    queryset = Role.objects.filter(is_active=True)
    serializer_class = RoleSerializer


class UserProfileViewSet(BaseModelViewSet):
    required_permission = 'base.view_userprofile'
    queryset = UserProfile.objects.filter(is_active=True).select_related('user')
    serializer_class = UserProfileSerializer

    def get_serializer_class(self):
        if self.action == 'create':
            return UserCreateSerializer
        return UserProfileSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        profile = serializer.save()
        return success_response(
            data=UserProfileSerializer(profile).data,
            message='使用者建立成功',
            status=201,
        )
