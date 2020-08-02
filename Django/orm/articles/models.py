from django.db import models #db와 직접적으로 연동할 수 있는 정보를 담고 있음.

# Create your models here.
class Article(models.Model):
    #id= models.AutoField(primary_key=True) #자동으로 생성
    title = models.CharField(max_length=100)
    content = models.TextField() 
    created_at = models.DateTimeField(auto_now_add=True) #DB의 하나의 레코드가 생성될때만 시간을 저장.
    updated_at = models.DateTimeField(auto_now=True) #DB의 하나의 레코드가 수정될때 마다 시간을 저장.

def __str__(self): #fstring 
    return f'{self.id}번 글 - {self.title} : {self.content}'

#step1 // models.py 생성 및 수정
#step2 // bash command: python manage.py makemigrations => migration(설계도) 파일 생성
#step3 //               python manage.py migrate => 실제 Database에 적용(테이블 생성)

#1. Create
#1-1. 첫번째 
#article.title = 'First'
#article.content = 'Wow!'
#article.save()

#1-2. 두번째
#article2 = Article(title='Second', content='two')
#article2.save()

#1-3. 세번째
#article3 = Article.objects.create(title='Third', content='three')


#2. Read
#2-1. all() => SELECT(SQL)
#articles = Article.objects.all()

#2-2. filter() => WHERE (SQL)
#articles = Article.objects.filter(title='First')

#2-3. get() 단수(1개)
#article = Article.objects.get(id=1)
#article = Article.objects.get(pk=1) pk=id_exact(primary key)

#get은 실제 있는 값들만 가져온다.
#article = Article.objects.get(title='first') #Error
#article = Article.objects.get(pk=10) #Error => get대신 filter 사용

#2-4. QuerySet(유사 리스트)
#articles = Article.objects.all()
#articles[0] #첫번째 데이터
#articles.first()
#articles[-1] #마지막 데이터
#articles.last() 
# OFFSET 1, LIMIT 2 => 2,3 출력(1 넘고 2게 출력)
# articles[1:3] #2~3번째
# articles[OFFSET:OFFSET+LIMIT]

#2-5. order_by()

