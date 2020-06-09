from django.urls import path
from . import views # from (app이름) import (파일이름)

urlpatterns = [
    # 안녕하세요
    # 점심
    path('index/', views.index), # path(경로, 함수)
    # 안녕하세요, <이름>
    path('hello/<name>/', views.hello), # <name> : <변수명>
    # 두 수 곱
    # path('multiply/<num1>/<num2>/', views.multiply)
    path('multiply/<int:num1>/<int:num2>/', views.multiply), # 기본 <str:num1> 띄어쓰기 불가능
    # django template language
    path('dtl/',views.dtl),
    # Is it your Birthday
    path('isUrBRD/', views.isUrBRD),

    path('throw/',views.throw),
    path('catch/', views.catch),

    #로또 번호 생성기
    #로또 번호 몇개를 생성할 것인지 Input으로 입력 받고, 그 갯수만큼 번호를 random으로 생성하여 보여주기.
    path('lotto/', views.lotto),
    path('generate/', views.generate),
    path('user_new/', views.user_new), # 회원 가입 양식
    path('user_create/', views.user_create), # 실제로 회원 생성
]