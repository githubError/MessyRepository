from django.contrib import admin

from .models import UserInfo, Skill, Education, Record, Function, Project

class SkillInline(admin.TabularInline):
    model = Skill
    extra = 0

class RecordInline(admin.TabularInline):
    model = Record
    extra = 0

class FunctionInline(admin.TabularInline):
    model = Function
    extra = 0


class EducationInline(admin.TabularInline):
    model = Education
    extra = 0


class UserInfoAdmin(admin.ModelAdmin):

    inlines = [
        SkillInline,
        RecordInline,
        EducationInline
    ]


class RecordAdmin(admin.ModelAdmin):

    inlines = [
        FunctionInline
    ]


admin.site.register(UserInfo, UserInfoAdmin)
admin.site.register(Skill)
admin.site.register(Education)
admin.site.register(Record, RecordAdmin)
admin.site.register(Function)
admin.site.register(Project)