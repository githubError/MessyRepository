from django.shortcuts import render
from django.views import generic

from .models import UserInfo, Skill, Record, Function, Education


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

        record_list = list()

        records = Record.objects.filter(user_id=user.id).order_by('-start_time')
        for record in records:
            record_dict = dict()
            functs = Function.objects.filter(record_id=record.id)
            record_dict['record'] = record
            record_dict['function'] = functs
            record_list.append(record_dict)

        education_list = Education.objects.filter(user_id=user.id)

        kwargs['user'] = user
        kwargs['skills'] = skills
        kwargs['record_list'] = record_list
        kwargs['education_list'] = education_list

        return kwargs