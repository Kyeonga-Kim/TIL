from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm, PasswordChangeForm
from django.contrib.auth import login as auth_login, logout as auth_logout 
from .forms import CustomUserChangeForm
from django.contrib.auth import update_session_auth_hash


# Create your views here.
def signup(request):
      #만약 로그인이 되었다면 index로 돌려보내기.
    if request.user.is_authenticated:
        return redirect('articles:index')

    if request.method == "POST":
        #User 생성
        # 1. POST로 넘어온 데이터 form에 넣기.
        # 2. form에서 유효성 검사
        form = UserCreationForm(request.POST)
        if form.is_valid(): #유효성 검사
            # 3. 유효하다면 database로 저장
            # 4. 저장 결과 확인이 가능한 페이지로 안내.
            user = form.save()
            #3-1. 저장했다면, 해당 user로 로그인!
            auth_login(request, user)


            return redirect('articles:index')



    else:
        #User 생성 양식 보여주기
        form = UserCreationForm()
    context = {
        'form' : form,
    }
    return render(request, 'accounts/signup.html', context)

def login(request):

    if request.method == "POST" :
        # User 검증 + 로그인
        # 1. POST로 넘어온 데이터 form 에 넣기.
        form = AuthenticationForm(request, request.POST)
        # 2. form 검증. (아이디, 비밀번호 맞음?)
        if form.is_valid():
            user = form.get_user()
            auth_login(request, user)
        # 3. 맞으면, 로그인 시켜줌.
        # 4. 로그인 결과 확인이 가능한 페이지로 안내.
        return redirect('articles:index')
    else :
        form = AuthenticationForm()
    context = {
        'form' : form

    }
    return render(request, 'accounts/login.html', context)

def logout(request): #POST
    if request.method=="POST":
        #Logout!
        auth_logout(request)

    return redirect("articles:index")

def delete(request): # POST
    # 만약, 로그인이 되어있다면
    if not request.user.is_authenticated:
        return redirect('articles:index')

    # User 삭제
    if request.method == 'POST':
        request.user.delete()

    return redirect('articles:index')

def edit(request):

    user = request.user
    if request.method =="POST":
        #User 업데이트
        #1.POST로 넘어온 데이터 form에 넣기
        form = CustomUserChangeForm(request.POST, instance=user)
        #2.form에서 데이터 검증하기
        if form.is_valid():
            form.save()

            return redirect('articles:index')
        #3.검증 통과하면, database에 저장
        #4.업데이트 결과 확인이 가능한 페이지로 안내

    else:
        #User 업데이트 양식 보여주기
        form = CustomUserChangeForm(instance=user)
        context = {
            'form' : form,
        }
        return render(request, 'accounts/edit.html', context)




def password(request):
    user = request.user
    if request.method == 'POST':
        #Password 변경
        #1. POST 로 넘어온 data를 form에 넣기
        form = PasswordChangeForm(user, request.POST)

        #2. form 유효성 검사
        if form.is_valid():
            user = form.save()
        #3. 검사를 통과했다면 저장
            update_session_auth_hash(request, user)
        #4. 어딘가로 돌려 보내기
            return redirect('accounts:edit')
    else:
        form = PasswordChangeForm(user) 
    context = {
        'form' : form,

    }
    return render(request, 'accounts/password.html', context)


