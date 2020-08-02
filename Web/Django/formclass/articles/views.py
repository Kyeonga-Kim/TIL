from django.shortcuts import render, redirect
from .models import Article, Comment
from .forms import ArticleForm, CommentForm
from django.contrib.auth.decorators import login_required

# Create your views here.
def index(request):
    articles = Article.objects.all()
    context = {
        'articles': articles,
    }
    return render(request, 'articles/index.html', context)


#로그인 검증  
# O -> new 함수 실행 
# X -> login 함수 실행
@login_required  #decorator
def new(request):
    if request.method == 'POST':
        # Database에 저장
        # 1. 요청에 실려온 data 꺼내오기
        # title = request.POST.get('title')
        # content = request.POST.get('content')
        # image = request.FILES.get('image')
        form = ArticleForm(request.POST, request.FILES)
        
        # 2-1. data 유효성 검사
        if form.is_valid():
            # (ModelForm) 2-2. Database에 저장
            article = form.save()
            # # 2-2. 검증된 data 꺼내오기
            # title = form.cleaned_data.get('title')
            # content = form.cleaned_data.get('content')
            # # 2-3. Database에 저장
            # article = Article(title=title, content=content)
            # article.save()
            # 3. 저장된 data를 확인할 수 있는 곳으로 안내
            return redirect('articles:detail', article.pk)

    else: # GET
        # 작성 양식 보여주기
        form = ArticleForm()
    context = {
        'form': form,
    }
    return render(request, 'articles/new.html', context)


def detail(request, pk):
    # Database에서 data 가져오기
    article = Article.objects.get(pk=pk)

    # 댓글 작성 양식 가져오기
    comment_form = CommentForm()

    context = {
        'article': article,
        'comment_form': comment_form,
    }
    return render(request, 'articles/detail.html', context)

@login_required 
def delete(request, pk): # POST
    article = Article.objects.get(pk=pk)
    if request.method == 'POST':
        article.delete()
    return redirect('articles:index')

@login_required 
def edit(request, pk):
    # 1. Database에서 data 가져오기
    article = Article.objects.get(pk=pk)

    if request.method == 'POST':
        # data 수정!
        
        # (ModelForm) 2-1. form에 data 집어넣기 + instance와 연결
        form = ArticleForm(request.POST, instance=article)
        # # 2-1. form에 data 집어넣기(검증 목적)
        # form = ArticleForm(request.POST)
        # 2-2. form에서 data 유효성 검사
        if form.is_valid():
            # (ModelForm) 2-3. Database에 저장
            article = form.save()
            # # 2-3. 검증된 data를 반영하기(저장)
            # article.title = form.cleaned_data.get('title')
            # article.content = form.cleaned_data.get('content')
            # article.save()
            # 3. 저장된 내용을 확인할 수 있는 페이지로 안내
            return redirect('articles:detail', article.pk)
    else:  
        # 수정 양식 보여주기!
        # (ModelForm) 2. Form에 data 채워 넣기
        form = ArticleForm(instance=article)
        # # 2. Form에 data 채워 넣기
        # form = ArticleForm(initial=article.__dict__)
    context = {
        'form': form,
    }
    return render(request, 'articles/edit.html', context)


def comments_new(request, article_pk): # POST
    # 1. 요청이 POST인지 점검
    if request.method == 'POST':
        # 2. form에 data를 집어넣기 (목적 == 유효성 검사)
        # request.POST #=> { 'content': '와 댓글!' }
        form = CommentForm(request.POST)
        # 3. form에서 유효성 검사를 시행
        if form.is_valid():
            # 4. 통과하면 database에 저장(?)
            comment = form.save(commit=False)
            # 4-1. article 정보 주입
            comment.article_id = article_pk
            comment.save()
    # 5. 생성된 댓글을 확인할 수 있는 곳으로 안내
    return redirect('articles:detail', article_pk)


def comments_delete(request, article_pk, pk): # POST
    # 0. 요청이 POST인지 점검
    if request.method == 'POST':
        # 1. pk를 가지고 삭제하려는 data 꺼내오기
        comment = Comment.objects.get(pk=pk)
        # 2. 삭제
        comment.delete()
    # 3. 삭제되었는지 확인 가능한 곳으로 안내
    return redirect('articles:detail', article_pk)


def comments_edit(request, article_pk, pk): # GET, POST
    # Database에서 수정하려 하는 data 가져오기
    comment = Comment.objects.get(pk=pk)
    # 0. 요청의 종류가 POST인지 GET인지 점검
    if request.method == 'POST':
        # 실제로 수정!
        # 1. form에 '넘어온 data' & '수정하려는 data' 집어넣기
        form = CommentForm(request.POST, instance=comment)
        # 2. 유효성 검사
        if form.is_valid():
            # 3. 검사를 통과했다면, save
            comment = form.save()
            # 4. 변경된 결과 확인하는 곳으로 안내
            return redirect('articles:detail', article_pk)
    else:
        # 수정 양식 보여주기!
        # 1. form class 초기화(생성)
        form = CommentForm(instance=comment)

    context = {
        'form': form,
    }
    return render(request, 'articles/comments_edit.html', context)
