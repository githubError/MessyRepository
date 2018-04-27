

from django.urls import path
from . import views

urlpatterns = [
    path('notify/',views.APIView.as_view(), name='api'),
    path('', views.IndexView.as_view(), name='index'),
]