from django.urls import path
from . import views

urlpatterns = [
    path('index/', views.index), # 게시글 목록
    # send / receive
    path('new/', views.new), # 게시글 작성 양식 (GET)
    path('create/', views.create), # 게시글 생성! (POST)
    path('detail/<int:pk>/', views.detail),
    path('delete/<int:pk>/', views.delete),
    path('edit/<int:pk>/', views.edit), # 게시글 수정 양식 (GET)
    path('update/<int:pk>/', views.update), # 게시글 수정! (POST)
]