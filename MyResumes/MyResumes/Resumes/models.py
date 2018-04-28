# coding: utf-8

from django.db import models
from django.utils import timezone
import datetime, time


class BaseModel(models.Model):

    def get_formater_date(self, date):
        formatStr = str('%s' % date)
        if formatStr == '1970-01-01':
            return '至今'
        formatStr = formatStr.replace('-', '.')
        formatStr = formatStr[:formatStr.__len__() - 3]
        return formatStr

    class Meta:
        abstract = True

# 基本信息
class UserInfo(BaseModel):
    name = models.CharField('姓名', max_length=10, default='')

    birthday = models.DateField('生日')

    telephone = models.CharField('电话', max_length=20, default='')

    email = models.EmailField('邮箱', default='')

    blog = models.URLField('博客', default='')

    github = models.URLField('GitHub', default='')

    introduce = models.TextField('自我介绍', default='')

    def __str__(self):
        return self.name

    def get_birthday(self):
        return self.get_formater_date(self.birthday)




# 专业技能
class Skill(BaseModel):
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)

    content = models.CharField('内容', max_length=200, default='')

    def __str__(self):
        return self.content


# 工作经历
class Record(BaseModel):

    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)

    company = models.CharField('单位名称', max_length=100, default='')

    company_url = models.URLField('单位链接', default='')

    position = models.CharField('职能', max_length=100, default='')  # 职位

    start_time = models.DateField('入职时间')
    end_time = models.DateField('离职时间', blank=True)

    summary = models.TextField('概述', default='') # 概述


    def get_start_time(self):
        return self.get_formater_date(self.start_time)

    def get_end_time(self):
        return self.get_formater_date(self.end_time)

    def __str__(self):
        return self.company



# 工作职能
class Function(BaseModel):

    record = models.ForeignKey(Record, on_delete=models.CASCADE)

    content = models.CharField('职能', max_length=200, default='')

    def __str__(self):
        return self.content



# 个人项目
class Project(BaseModel):
    
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)
    name = models.CharField('项目名称', max_length=50, blank=False)
    url = models.URLField('项目链接', default='https://github.com/githubError/')
    content = models.TextField('描述', default='')

    def __str__(self):
        return self.name



# 教育经历
class Education(BaseModel):

    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)

    school = models.CharField('学校', max_length=100, default='')

    school_url = models.URLField('学校链接', max_length=100, default='')

    major = models.CharField('主修专业', max_length=100, default='')    # 主修专业

    edu_grade = models.CharField('学历', max_length=50, default='')  # 学历

    start_time = models.DateField('开始时间')
    end_time = models.DateField('结束时间', blank=True)


    def get_start_time(self):
        return self.get_formater_date(self.start_time)

    def get_end_time(self):
        return self.get_formater_date(self.end_time)

    def __str__(self):
        return self.school