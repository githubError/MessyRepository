from django.shortcuts import render
from django.views import generic
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
import threading
from Resumes.utils import post_resumes_notify_email, post_articel_notify_email


from .models import UserInfo, Skill, Record, Function, Education, Project


class IndexView(generic.ListView):
    template_name = 'index.html'
    http_method_names = ['get']

    model = UserInfo

    def get_context_data(self, *, object_list=None, **kwargs):

        t = threading.Thread(target=post_resumes_notify_email, name='post_resumes_notify_email', args=(self.request,))
        t.start()

        kwargs = super(IndexView,self).get_context_data(**kwargs)
        user = UserInfo.objects.all()[0]

        skills = Skill.objects.filter(user_id=user.id).order_by('id')

        record_list = list()

        records = Record.objects.filter(user_id=user.id).order_by('-start_time')
        for record in records:
            record_dict = dict()
            functs = Function.objects.filter(record_id=record.id)
            record_dict['record'] = record
            record_dict['function'] = functs
            record_list.append(record_dict)

        education_list = Education.objects.filter(user_id=user.id)

        project_list = Project.objects.filter(user_id=user.id).order_by('id')

        kwargs['user'] = user
        kwargs['skills'] = skills
        kwargs['record_list'] = record_list
        kwargs['education_list'] = education_list
        kwargs['project_list'] = project_list

        return kwargs



class APIView(generic.ListView):
    http_method_names = ['post']

    @csrf_exempt    # 防止POST请求403错误
    def post(self, request, *args, **kwargs):
        urlpath = request.POST['urlpath']
        title = request.POST['title']
        userAgent = request.META.get('HTTP_USER_AGENT', None)
        
        t = threading.Thread(target=post_articel_notify_email, name='post_resumes_notify_email', args=(userAgent, urlpath, title))
        t.start()

        response = HttpResponse(b'{"code":"1000", "msg":"success", "body":{}}',content_type='application/json')
        response["Access-Control-Allow-Origin"] = "*"
        response["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS"
        response["Access-Control-Max-Age"] = "1000"
        response["Access-Control-Allow-Headers"] = "*"

        return response
