from django.shortcuts import render

# Create your views here.
def index(request):
    hello = 'hello :)'
    lunch = '라멘'
    context = {
        'hello': hello,
        'l': lunch
    }
    return render(request, 'pages/index.html', context)


def hello(request, name):
    context = {
        'name': name
    }
    return render(request, 'pages/hello.html', context)


def times(request, num1, num2):
    result = int(num1) * int(num2)
    context = {
        'num1': num1,
        'num2': num2,
        'result': result
    }
    return render(request, 'pages/times.html', context)


from datetime import datetime
def dtl(request):
    foods = ['짜장면', '탕수육', '짬뽕', '양장피']
    sentence = 'Life is short, you need python'
    fruits = ['apple', 'banana', 'cucumber', 'mango']
    datetimenow = datetime.now()
    empty_list = []

    context = {
        'foods': foods,
        'sentence': sentence,
        'fruits': fruits,
        'datetimenow': datetimenow,
        'empty_list': empty_list,
    }
    return render(request, 'pages/dtl.html', context)


def bday(request):
    # 1. 오늘 날짜 가져오기
    today = datetime.now()
    # 2. month, day 가져와서 오늘 날짜와 비교하기
    result = (today.month == 11 and today.day == 23)
    context = {
        'result': result
    }
    return render(request, 'pages/bday.html', context)


def throw(request):
    context = {

    }
    return render(request, 'pages/throw.html', context)

def catch(request):
    # request.GET #=> { 'username': 'nwith', 'message': 'hi' }
    username = request.GET.get('username') #=> 'nwith'
    message = request.GET.get('message') #=> 'hi'
    context = {
        'username': username,
        'message': message,
    }
    return render(request, 'pages/catch.html', context)

def lotto(request):
    context = {

    }
    return render(request, 'pages/lotto.html', context)

import random
def generate(request):
    count = int(request.GET.get('count'))

    lotto_numbers = range(1, 46)

    lottos = []
    for n in range(count):    
        lottos.append(sorted(random.sample(lotto_numbers, 6)))

    context = {
        'lottos': lottos
    }
    return render(request, 'pages/generate.html', context)


def user_new(request):
    context = {

    }
    return render(request, 'pages/user_new.html', context)


def user_create(request):
    username = request.POST.get('username')
    pw = request.POST.get('pw')
    context = {
        'username': username,
        'pw': pw
    }
    return render(request, 'pages/user_create.html', context)
