# CRUD

1. Python 가상 환경 생성
```
python -m venv venv
```

2. Python 가상 환경 활성화 (VS Code 기능)
    - Ctrl + Shift + p
    - 'Python: Select Interpreter'
    - 가상 환경 'venv' 선택

3. Django 설치
```
pip install django==2.2.13
```

4. Django Project 생성
```
django-admin startproject crud .
```

5. Django App 생성
```
python manage.py startapp articles
```

6. Django App 등록
    - settings.py > INSTALLED_APPS
    - 'articles' 추가

7. 언어 및 시간 설정
    - settings.py
    - `LANGUAGE_CODE = 'ko-kr'`
    - `TIME_ZONE = 'Asia/Seoul'`

8. base.html 설정
    - settings.py
    - TEMPLATES - DIRS
    - `os.path.join(BASE_DIR, 'templates')` 추가
    - 최상위 폴더에서 templates 폴더 생성
    - templates > base.html 생성

9. urls.py 분리
    - articles > urls.py 생성
    - crud > urls.py에서 include로 path 추가