#1
#IMDB 데이터셋 사용
#- 리뷰 데이터 전처리(불용어, 특수문자, 숫자 등 제거, 어근 동일화 등)
#- DTM 생성(DocumentTermMatrix)
#- train/test data set 분리
#- 열의 크기가 매우 크므로 최소 10번 이상 등장한 단어 대상으로 할 것
imdb<-read.csv("Data/IMDB Dataset.csv", stringsAsFactors = FALSE, encoding = "utf8") 
summary(imdb) #215519 객체 , 2개 변수(review/sentiment)
imdb<-imdb[1:10000,]  #10000개만 
str(imdb)
table(imdb$sentiment)
imdb$sentiment<-factor(imdb$sentiment) #sentiment는 factor로 변환


#데이터 전처리
library(stringr)

#시제 일치
imdb$review<-str_replace_all(imdb$review,"('m)|('re)|('s)|('ve)|('d)","")
imdb$review<-str_replace_all(imdb$review,"( amn't)|( aren't)|( isn't)|( wasn't)|( weren't)|( ben't)"," be not")
imdb$review<-str_replace_all(imdb$review,"( am)|( are)|( is)|( was)|( were)|( be )","")

#<>나 <br /> 제거
imdb$review<-str_replace_all(imdb$review, "<.+>|<br / >","") 

# 따옴표 있는 문장 제거
imdb$review<-str_replace_all(imdb$review, "\".+\"","") 

#특수문자 제거
imdb$review<-str_replace_all(imdb$review, "[[:punct:]]","")

#한글 제거
imdb$review<-str_replace_all(imdb$review, "[가-힣]+","") 

imdb$review[1:20]

#텍스트 마이닝
library(tm)
imdb_corpus<-VCorpus(VectorSource(imdb$review)) #
inspect(imdb_corpus)
imdb_corpus


#Wordstemming : 어근 동일화
library(SnowballC)
imdb_clean<-tm_map(imdb_corpus,stemDocument)

#DTM으로 변환
imdb_clean<-DocumentTermMatrix(imdb_clean, control = list(tolower=T, #소문자
                                                            stripWhitespace=T, #여백제거
                                                            removeNumbers=T, #숫자제거
                                                            stopwords=T)) #불용어 제거
                                                              
inspect(imdb_clean)
imdb_clean

#train/test data 분류작업
set.seed(2020)
imdb_sample<-sample(10000,8000) #train:80%, test:20%
imdb_train<-imdb_clean[imdb_sample,]
imdb_test<-imdb_clean[-imdb_sample,]
inspect(imdb_test)
inspect(imdb_train)

train_label<-imdb[imdb_sample,]$sentiment #만들어줄 모델과 비교할 라벨 지정
test_label<-imdb[-imdb_sample,]$sentiment

imdb_freq_word<-findFreqTerms(imdb_train, 10) #train데이터 에서 10번이상 나온 단어

imdb_freq_train<-imdb_train[,imdb_freq_word]
imdb_freq_test<-imdb_test[,imdb_freq_word]
imdb_freq_train
imdb_freq_test

#Naivebays

convert_counts<-function(x){ 
  x<-ifelse(x>0,"yes","no") #DTM에서 빈도수 0이면 no, 1이상 yes
}

imdb_train_final<-apply(imdb_freq_train, MARGIN = 2, convert_counts) #margin= 2: 열단위

imdb_test_final<-apply(imdb_freq_test, MARGIN = 2, convert_counts)

#분류기(모델) 생성
library(e1071)
imdb_classifier<-naiveBayes(imdb_train_final, train_label)
imdb_pred<-predict(imdb_classifier,imdb_test_final)
imdb_pred

#교차표 확인
library(gmodels)
CrossTable(imdb_pred,
           test_label,
           prop.t = F,
           prop.r = F,
           dnn=c("predict","actual"))
sum(imdb_pred==test_label)*100/length(test_label) #정확도
