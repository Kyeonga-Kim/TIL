from django import forms
from django.contrib.auth.forms import UserChangeForm
from django.contrib.auth import get_user_model


class CustomUserChangeForm(UserChangeForm):
    class Meta:
        # 유저 모델
        model = get_user_model() # => auth.User 를 가져옴
        fields = ('username', 'email', 
                'first_name', 'last_name', 
                )