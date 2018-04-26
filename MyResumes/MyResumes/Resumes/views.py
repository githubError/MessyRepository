from django.shortcuts import render
from django.views import generic
from django.core.mail import send_mail
import datetime

from MyResumes import settings
from .models import UserInfo, Skill, Record, Function, Education


class IndexView(generic.ListView):
    template_name = 'index.html'
    http_method_names = ['get']

    model = UserInfo

    # def get_queryset(self):
    #     return UserInfo.objects.all()[0]

    def get_context_data(self, *, object_list=None, **kwargs):

        # print(self.request.META)

#         ip = self.request.META['REMOTE_ADDR']
#         if 'HTTP_X_FORWARDED_FOR' in self.request.META.keys():
#             ip =  self.request.META['HTTP_X_FORWARDED_FOR']  
#         else:  
#             ip = self.request.META['REMOTE_ADDR']

#         emial_content = ''' 
# 你有一条新访问!  
#     时间：%s\n

# 来源信息：\n
#     IP地址：%s\n
#     浏览器类型：%s\n

#         ''' % (datetime.datetime.now(), ip, self.request.META['HTTP_USER_AGENT'])

#        send_mail('简历有一条新访问', '内容', settings.EMAIL_HOST_USER, [settings.EMAIL_HOST_USER])

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