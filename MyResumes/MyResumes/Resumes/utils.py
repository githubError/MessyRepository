from django.core.mail import send_mail
import datetime, threading

def post_resumes_notify_email(request):
    print('-----> 发送邮件')

    userAgent = praser_userAgent(request.META.get('HTTP_USER_AGENT', None))

    emial_content = ''' 
你有一条新访问!  
    时间：%s\n
    userAgent：%s\n
       ''' % (datetime.datetime.now(), userAgent)

    try:
        send_mail('简历有一条新访问', emial_content, 'githuberror@163.com', ['githuberror@163.com'])
    except Exception as e:
        print('-----> 发送邮件异常 %s' % e)
    finally:
        print('-----> 邮件发送完毕')




def post_articel_notify_email(userAgent, urlpath, title):
    print('-----> 发送邮件')

    emial_content = ''' 
    你有一条新访问!  
        时间：%s\n
        userAgent：%s\n
        标题: %s\n
        地址: %s\n
           ''' % (datetime.datetime.now(), userAgent, title, urlpath)

    try:
        send_mail('主页有一条新访问', emial_content, 'githuberror@163.com', ['githuberror@163.com'])
    except Exception as e:
        print('-----> 发送邮件异常 %s' % e)
    finally:
        print('-----> 邮件发送完毕')




def praser_userAgent(userAgent):
    return userAgent
