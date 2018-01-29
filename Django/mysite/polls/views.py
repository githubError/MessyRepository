from django.shortcuts import render

# Create your views here.

from django.http import HttpResponse

from django.http import HttpResponseRedirect
from django.urls import reverse

from django.shortcuts import render, get_object_or_404

from .models import Question, Choice

from django.http import Http404



'使用template 的 loader创建相应的render'
# from django.template import loader
# def index(request):
#
#     lastest_question_list = Question.objects.order_by('-pub_date')[:5]
#
#     template = loader.get_template('polls/index.html')
#
#     context = {
#         'latest_question_list' : lastest_question_list
#     }
#
#     return HttpResponse(template.render(context, request))



def index(request):

    lastest_question_list = Question.objects.order_by('-pub_date')[:5]

    context = {
        'latest_question_list' : lastest_question_list
    }

    return render(request, 'polls/index.html', context)


def detail(request, question_id):

    # try:
    #     question = Question.objects.get(pk=question_id)
    # except Question.DoesNotExist:
    #     raise Http404("该问题不存在")

    question = get_object_or_404(Question, pk=question_id)

    return render(request, 'polls/detail.html', {'question' : question})




def results(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    return render(request, 'polls/results.html', {'question': question})



def vote(request, question_id):

    question = get_object_or_404(Question, pk=question_id)

    try:
        selected_choice = question.choice_set.get(pk=request.POST['choice'])
    except (KeyError, Choice.DoesNotExist):
        return render(request, 'polls/detail.html',{
            'question': question,
            'error_message':"你还没有选择.",
        })

    else:
        selected_choice.votes += 1
        selected_choice.save()

    return HttpResponseRedirect(reverse('polls:results', args=(question.id,)))
