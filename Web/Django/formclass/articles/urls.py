from django.urls import path
from . import views

app_name = 'articles'

urlpatterns = [
    path('', views.index, name='index'),
    path('new/', views.new, name='new'),
    path('<int:pk>/', views.detail, name='detail'),
    path('<int:pk>/delete/', views.delete, name='delete'),
    path('<int:pk>/edit/', views.edit, name='edit'),
    # /articles/1/comments/new/
    path('<int:article_pk>/comments/new/', views.comments_new, name='comments_new'),
    path('<int:article_pk>/comments/<int:pk>/delete/', views.comments_delete, name='comments_delete'),
    path('<int:article_pk>/comments/<int:pk>/edit/', views.comments_edit, name='comments_edit'),
]