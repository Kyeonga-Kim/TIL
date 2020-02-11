---
typora-root-url: images
---

typora-root-url: images

## Classification: Naive Bayes(나이브 베이즈)



```R
#두 확률 변수의 사전 확률과 사후 확률 사이의 관계를 나타내는 정리
#어느 여행 동호회 전체 사람수: 100명, 이 중 40명이 여성, 여성중 16명이 기혼,
#남성중 30명이 기혼일때 임의로 한명을 뽑은 사람이 기혼일때, 이 회원이 여성일 확률?

#여성을 A, 남성을 B, 기혼을 C
#p(A|C)=0.4*0.4/0.4*0.4+0.6*0.5

sms_raw<-read.csv("Data/sms_spam_ansi.txt", stringsAsFactors = FALSE)
str(sms_raw)
sms_raw$type<-factor(sms_raw$type)
str(sms_raw$type)
table(sms_raw$type) #ham 4812, spam 747
```



### 텍스트 정제

```R

#Corpus
#VCorpus: 문서를 Corpus Class로 만들어 주는 함수
#VectorSource(): 데이터 소스 객체 생성

sms_corpus<-VCorpus(VectorSource(sms_raw$text))
inspect(sms_corpus[1:10])
sms_corpus[1]
sms_corpus[[1]]
as.character(sms_corpus[[1]]) #1행 내용 
lapply(sms_corpus[1:5], as.character) #1행~5행까지 문서 내용 출력

#소문자로 변환
sms_corpus_clean<-tm_map(sms_corpus, content_transformer(tolower)) 
sms_corpus_clean[[1]]
as.character(sms_corpus_clean[[1]])

#숫자제거
sms_corpus_clean<-tm_map(sms_corpus_clean, removeNumbers) 
inspect(sms_corpus_clean[1:5])

#구두점 제거
sms_corpus_clean<-tm_map(sms_corpus_clean, removePunctuation)

#불용어 제거
#and, but, so, I, she..
sms_corpus_clean<-tm_map(sms_corpus_clean, removeWords, stopwords("english"))
inspect(sms_corpus_clean[1:5])

#정규표현식
replacePunctuation<-function(x){
   gsub("[[:punct:]]+"," ",x)
 }

replacePunctuation("hi+*#%hello$%")

x="대한민국 대한 민국 대한민국"
gsub("대한민국","코리아",x)

#형태소 분석
install.packages("SnowballC")
library(SnowballC)
wordStem(c("learn","learned","learning","learns"))#단어의 어근 추출

#stemDocument: 텍스트 문서의 전체 코퍼스에 wordstem을 적용
sms_corpus_clean<-tm_map(sms_corpus_clean, stemDocument)
inspect(sms_corpus_clean[1:5])

#추가 여백 제거
sms_corpus_clean<-tm_map(sms_corpus_clean,stripWhitespace)
inspect(sms_corpus_clean[1:5])

lapply(sms_corpus[1:5], as.character)
inspect(sms_corpus_clean[1:5])
```

### 토큰화

```R
#DocumentTermMatrix(): Corpus으로부터 문서별 특정 문자의 빈도표 생성
#row: sms메세지, columns: 단어
sms_dtm1<-DocumentTermMatrix(sms_corpus_clean)

sms_dtm2<-DocumentTermMatrix(sms_corpus, control = list(tolower=T, 
                                        removeNumbers=T, 
                                              stopwords=T, 
                                              removePunctuation=T,
                                              stemming=T))
```

### WordCloud으로 표현

```R
#패키지 설치
install.packages("wordcloud")
library(wordcloud)

#wordcloud로 표현
wordcloud(sms_corpus_clean,
          min.freq = 50, 
          max.words = 100,
          random.color = T,
          random.order = F,
          colors = brewer.pal(10,"Paired")) 
#min.freq옵션 : 표현할 단어 최소 갯수, random.order=F: 원모양

#spam과 ham에 대한 Wordcloud
spam<-subset(sms_raw, type=="spam")
ham<-subset(sms_raw, type=="spam")

wordcloud(spam$text, max.words = 40, scale = c(5,1))
wordcloud(ham$text, max.words = 40, scale = c(5,1))


```



## Naive Bays적용

```R

sms_dtm_train<-sms_dtm2[1:4169,] #train
sms_dtm_test<-sms_dtm2[4170:5559,] #test

sms_train_label<-sms_raw[1:4169,]$type #종속변수를     label로 빼기
sms_test_label<-sms_raw[4170:5559,]$type 

sms_freq_words<-findFreqTerms(sms_dtm_train,5) #최소 5번 이상 등장한 단어

convert_counts<-function(x){
  x<-ifelse(x>0, "yes","no")
}

sms_dtm_freq_train<-sms_dtm_train[,sms_freq_words]
sms_dtm_freq_test<-sms_dtm_test[,sms_freq_words]

sms_train<-apply(sms_dtm_freq_train, MARGIN = 2, convert_counts) #margin=1:행단위, 2: 열단위
sms_test<-apply(sms_dtm_freq_test, MARGIN = 2, convert_counts)

#나이브베이즈 적용
#e1071 패키지 설치
install.packages("e1071")
library(e1071)

sms_classifier<-naiveBayes(sms_train,sms_train_label)
str(sms_classifier)
sms_test_pred<-predict(sms_classifier,sms_test)
sms_test_pred

#정확도 
library(gmodels)
CrossTable(sms_test_pred, 
           sms_test_label,
           prop.t = F,
           prop.r = F,
           dnn=c("predicted", "actual"))



```

## * laplace smoothing 

```R
#laplace: 확률이 0인 변수에 대해서 +1를 해준다.
sms_classifier2<-naiveBayes(sms_train, sms_train_label,  laplace = 1) #laplace: 확률이 0인 변수에 대해서 +1를 해준다.
sms_test_pred2<-predict(sms_classifier2, sms_test)
CrossTable(sms_test_pred2, 
           sms_test_label,
           prop.t = F,
           prop.r = F,
           dnn=c("predicted", "actual"))
```



## + Practice Naive Bays using mushroom data

```R
mushroom<-read.csv("Data/mushrooms.csv")
mushrooms<-mushroom[-1]
mushroom_train<-mushrooms[1:5687,] #train
mushroom_test<-mushrooms[5688:8124,] #test
train_label<-mushroom[1:5687,]$type
test_label<-mushroom[5688:8124,]$type

mushroom_naive<-naiveBayes(mushroom_train, train_label)
mush_pred<-predict(mushroom_naive, mushroom_test)
mush_pred

CrossTable(mush_pred,
           test_label,
           prop.t = F,
           prop.r = F,
           dnn=c("predicted","actual"))

sum(mush_pred==test_label)*100/length(test_label) #정확도 : 91.91629%
mushroom_naive2<-naiveBayes(mushroom_train, train_label, laplace = 1)
mush_pred2<-predict(mushroom_naive2, mushroom_test)

CrossTable(mush_pred2,
           test_label,
           prop.t = F,
           prop.r = F,
           dnn=c("predicted","actual"))
sum(mush_pred2==test_label)*100/length(test_label) #정확도: 91.79319%
```

