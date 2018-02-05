from django.shortcuts import render
from django.views import generic

from .models import UserInfo, Skill

class IndexView(generic.ListView):
    template_name = 'index.html'
    http_method_names = ['get']

    model = UserInfo

    # def get_queryset(self):
    #     return UserInfo.objects.all()[0]

    def get_context_data(self, *, object_list=None, **kwargs):

        kwargs = super(IndexView,self).get_context_data(**kwargs)
        user = UserInfo.objects.all()[0]

        skills = Skill.objects.filter(user_id=user.id)
        for skill in skills:
            print(skill.content)

        kwargs['user'] = user
        return kwargs