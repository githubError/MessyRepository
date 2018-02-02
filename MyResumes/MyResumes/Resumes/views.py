from django.shortcuts import render
from django.views import generic

from .models import UserInfo

class IndexView(generic.ListView):
    template_name = 'index.html'
    context_object_name = 'userinfo'

    def get_queryset(self):
        return UserInfo.objects.all()[0]