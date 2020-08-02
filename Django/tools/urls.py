from django.urls import path
from . import views # from (app이름) import (파일이름)

urlpatterns = [
    path('', views.index),
    
]