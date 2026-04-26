from django.contrib.auth import get_user_model
from rest_framework import serializers
from ..models.role import Role
from ..models.user_profile import UserProfile

User = get_user_model()


class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ['id', 'name', 'code', 'description', 'is_active', 'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at']


class UserProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    role_ids = serializers.PrimaryKeyRelatedField(
        source='roles',
        queryset=Role.objects.all(),
        many=True,
        required=False,
    )

    class Meta:
        model = UserProfile
        fields = [
            'id', 'username', 'email',
            'display_name', 'phone', 'role_ids',
            'is_active', 'created_at', 'updated_at',
        ]
        read_only_fields = ['created_at', 'updated_at']


class UserCreateSerializer(serializers.Serializer):
    """建立新使用者（同時建立 auth_user + UserProfile）"""
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(write_only=True, min_length=8)
    email = serializers.EmailField(required=False, default='')
    display_name = serializers.CharField(max_length=100, required=False, default='')
    phone = serializers.CharField(max_length=20, required=False, default='')
    role_ids = serializers.PrimaryKeyRelatedField(
        queryset=Role.objects.all(),
        many=True,
        required=False,
        default=list,
    )

    def validate_username(self, value):
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError('此帳號已存在')
        return value

    def create(self, validated_data):
        role_ids = validated_data.pop('role_ids', [])
        display_name = validated_data.pop('display_name', '')
        phone = validated_data.pop('phone', '')

        user = User.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password'],
            email=validated_data.get('email', ''),
        )
        profile = UserProfile.objects.create(
            user=user,
            display_name=display_name,
            phone=phone,
        )
        if role_ids:
            profile.roles.set(role_ids)
        return profile
