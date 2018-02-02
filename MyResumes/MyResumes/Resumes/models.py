# coding: utf-8

from django.db import models
from django.utils import timezone
import datetime


# 基本信息

class UserInfo(models.Model):
    name = models.CharField('姓名', max_length=10, default='')

    birthday = models.DateField('生日')

    telephone = models.CharField('电话', max_length=20, default='')

    email = models.EmailField('邮箱', default='')

    blog = models.URLField('博客', default='')

    github = models.URLField('GitHub', default='')

    introduce = models.TextField('自我介绍', default='')

    def __str__(self):
        return self.name




# 专业技能
class Skill(models.Model):
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)

    content = models.CharField('内容', max_length=200, default='')

    def __str__(self):
        return self.content


# 工作经历
class Record(models.Model):

    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)

    company = models.CharField('单位名称', max_length=100, default='')

    company_url = models.URLField('单位链接', default='')

    position = models.CharField('职能', max_length=100, default='')  # 职位

    start_time = models.DateField('入职时间')
    end_time = models.DateField('离职时间')

    summary = models.TextField('概述', default='') # 概述

    def __str__(self):
        return self.company



# 工作职能
class Function(models.Model):

    record = models.ForeignKey(Record, on_delete=models.CASCADE)

    content = models.CharField('职能', max_length=200, default='')

    def __str__(self):
        return self.content



# 教育经历
class Education(models.Model):

    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)

    school = models.CharField('学校', max_length=100, default='')

    school_url = models.URLField('学校链接', max_length=100, default='')

    major = models.CharField('主修专业', max_length=100, default='')    # 主修专业

    edu_grade = models.CharField('学历', max_length=50, default='')  # 学历

    start_time = models.DateField('开始时间')
    end_time = models.DateField('结束时间')

    def __str__(self):
        return self.school