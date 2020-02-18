## Day11

### 텍스트 마이닝

``` R
library(tm)
my.text.location<-"c:/R_project/Data/ymbaek_papers"
mypaper<-VCorpus(DirSource(my.text.location))
mypaper
summary(mypaper)
mypaper[[2]]$content #문서 내용 보기
mypaper[[2]]$meta 

meta(mypaper[[2]], tag="author")<-"g.d.dong"
mypaper[[2]]$meta

#tm_map(코퍼스, 사전처리함수)
#특수기호 전후의 단어 추출
library(stringr)
myfunc<-function(x){
  str_extract_all(x,"[[:alnum:]]{1,}[[:punct:]]{1}[[:alnum:]]{1,}")
}
mypuncts<-lapply(mypaper, myfunc)
table(unlist(mypuncts))

#숫자 추출
myfunc<-function(x){
  str_extract_all(x,"[[:digit:]]{1,}")
}
mydigits<-lapply(mypaper, myfunc)
table(unlist(mydigits))

#고유명사 추출
myfunc<-function(x){
  str_extract_all(x,"[[:Upper:]]{1}[[:alpha:]]+")
}
myuppers<-lapply(mypaper, myfunc)
table(unlist(myuppers))

mytempfunc<-function(myobj,oldexp,newexp){
  newobject<-tm_map(myobj, content_transformer(function(x,pattern) gsub(pattern, newexp, x)), oldexp)
newobject
  }
#Corpus 객체에서 pattern적용해서 바꿔줄때(str_replace_all과는 다름) 

```



```R
#어근 동일화
#문자 개수 계산 함수
mycharfunc<-function(x){
  str_extract_all(x,".")
}

#전처리 전
mychar<-lapply(mypaper, mycharfunc)
table(unlist(mychar))
myuniquechar0<-length(table(unlist(mychar))) 
#79가지 문자 구성
mytotalchar0<-sum(table(unlist(mychar))) 
#총 문자 갯수 : 24765

mywordfunc<- function(x) {
  str_extract_all(x,boundary("word"))
}
myword<-lapply(mypaper, mywordfunc)
table(unlist(myword))
myuniqueword0<-length(table(unlist(myword)))
mytotalword0<-sum(table(unlist(myword))) 
```



```R
#전처리 작업
mycorpus<-mytempfunc(mypaper,'-collar','collar')
mycorpus<-mytempfunc(mycorpus,'e\\.g\\.','for ex')
mycorpus<-mytempfunc(mycorpus,'and/or','and or')

mycorpus<- tm_map(mycorpus, removePunctuation)
mycorpus<- tm_map(mycorpus, stripWhitespace)
mycorpus<- tm_map(mycorpus, content_transformer(tolower))
mycorpus<- tm_map(mycorpus, removeWords, words=stopwords("SMART"))
mycorpus<- tm_map(mycorpus, stemDocument, language='en')

mychar<-lapply(mycorpus, mycharfunc)
myuniquechar1<-length(table(unlist(mychar)))
#41가지 문자 구성
mytotalchar1<-sum(table(unlist(mychar))) 
#총 문자 갯수 : 14693

myword<-lapply(mycorpus, mywordfunc)
myuniqueword1<-length(table(unlist(myword)))
mytotalword1<-sum(table(unlist(myword))) 
```

```R
#전처리 후 결과값 dataframe으로 출력
result.comparing<-rbind(c(myuniquechar0, myuniquechar1),
                         c(mytotalchar0, mytotalchar1),
                         c(myuniqueword0, myuniqueword1),
                         c(mytotalword0, mytotalword1))
result.comparing
colnames(result.comparing)<-c("before","after")
rownames(result.comparing)<-c("고유문자수","총문자수", "고유단어수", "총단어수")

result.comparing

           before after
고유문자수     79    41
총문자수    24765 14693
고유단어수   1151   710
총단어수     3504  2060
```

### TF-IDF

* 단어의 빈도수 (DTM으로부터)로만 중요도 판단

* 무조건 DTM 생성후 TF-IDF생성

* 문서: d 

* 단어 : t

* 문서의 총 갯수:  n

* TF(d,t) : 특정문서 d에서 특정단어 t의 등장횟수

  

DF(t) : 특정단어가 t가 등장한 "문서의 수" *단어 등장 횟수 X

IDF(d,t) : log((전체 문서 갯수)/(특정단어가 등장한 문서 갯수(DF) + 1))

TFIDF : TF * IDF 

=> 특정 단어 빈도가 높을 수록 전체 문서들 중 그 단어를 포함한 문서가  적을수록  TF-IDF가 클수록 중요한 단어



```R
dtm.e.tfidf<-DocumentTermMatrix(mycorpus, control = list(weightning=function(x) weightTfIdf(x, normalize = False)))

dtm.e.tfidf

#TF는 크지만 TFIDF는 작은 단어들 검출
as.matrix(dtm.e[,])
as.matrix(dtm.e.tfidf[,])

install.packages("KoNLP")
#KoNLP 패키지 다운 막힘                                      #따로 KoNLP패키지 다운후 R패키지 폴더에 넣어줌

library(httpuv)
install.packages("rgdal")
library(rgdal)
install.packages("geojsonio")
library(geojsonio)
install.packages("rgeos")
library(rgeos)
install.packages("Sejong")
library(Sejong)
install.packages("hash")
library(hash)
install.packages("tau")
library(tau)
install.packages("RSQLite")
library(RSQLite)

library(KoNLP)
sentence <- '아버지가 방에 들어가신다'
extractNoun(sentence)

```

### ANN(인공신경망) : neuralnet

```R
concrete<-read.csv("Data/concrete.csv")
nomalize<-function(x){
  return((x-min(x))/(max(x)-min(x)))
}
concrete_norm<-as.data.frame(lapply(concrete,nomalize))
str(concrete_norm)
concrete_train<-concrete_norm[1:773,]
concrete_test<-concrete_norm[774:1030,]
install.packages("neuralnet")
library(neuralnet)

concrete_model<-neuralnet(formula = strength~., data=concrete_train)
str(concrete_model)
plot(concrete_model)

concrete_test[1:8]
model_results<-compute(concrete_model,concrete_test[1:8])
str(model_results) #net_result가 출력값

pre_str<-model_results$net.result
pre_str
#상관관계를 통해 모델 성능 출력
cor(pre_str, concrete_test$strength)  #0.805728


#hidden layer=5로 주었을때
concrete_model2<-neuralnet(formula = strength~., data=concrete_train, hidden = 5)
plot(concrete_model2)

model_results2<-compute(concrete_model2,concrete_test[1:8])
pre_str2<-model_results2$net.result
cor(pre_str2, concrete_test$strength) #0.9354758 

#결과: hidden layer=5 로 줬을때 상관관계가 높게 나옴
```

### Practice

```R
#Sepal.Length Sepal.Width Petal.Length 3가지 독립변수로 
#Petal.Width 변수 분류

library(neuralnet)
data(iris)
iris<-iris[-5]
str(iris)
set.seed(2020)
sample<-sample(150,105) #70% 랜덤값값
iris_train<-iris[sample,]
iris_test<-iris[-sample,]

iris_model<-neuralnet(formula = Petal.Width~., data=iris_train)
plot(iris_model) #error: 1.766698 steps:3947
str(iris_model)
iris_model[1:3] #독립변수 : Sepal.Length Sepal.Width Petal.Length 

iris_results<-compute(iris_model,iris_test[1:3])
str(iris_results) 
iris_str<-iris_results$net.result
cor(iris_str, iris_test$Petal.Width) #0.9640332


#hidden=5로 줬을때
iris_model5<-neuralnet(formula = Petal.Width~., data=iris_train, hidden=5)
plot(iris_model5) #error: 1.064656, steps:31324

iris_results2<-compute(iris_model5,iris_test[1:3])
iris_str2<-iris_results2$net.result 
cor(iris_str2, iris_test$Petal.Width) #0.967497
```



