movie<-read.csv("Data/movie-pang02.csv", stringsAsFactors = FALSE)
str(movie)
summary(movie)
movie$class<-factor(movie$class)
table(movie$class) #neg:1000 , pos:1000

class(movie$class)

#각text를 VCorpus객체로
library(tm)
movie_corpus<-VCorpus(VectorSource(movie$text))
inspect(movie_corpus[1:10])

movie_corpus[[1]]

#movie_corpus_clean<-tm_map(movie_corpus,stripWhitespace)
#inspect(movie_corpus_clean[[1]])

#데이터 정제후 단어별 행렬로 변환

#구두점 제거
replacePunctuation<-function(x){
  gsub("[[:punct:]]+"," ",x)
}

movie_clean<-replacePunctuation(movie_corpus)
movie_clean<-DocumentTermMatrix(movie_corpus, control = list(stripWhitespace=T, #여백제거
                                                     removeNumbers=T, #숫자제거
                                                     stopwords=T,
                                                     stemming=T)) 
set.seed(2020)
movie_sample<-sample(2000,1800)
movie_dtm_train<-movie_clean[movie_sample,]
movie_dtm_test<-movie_clean[-movie_sample,]



movie_train_label<-movie[movie_sample,]$class
movie_test_label<-movie[-movie_sample,]$class

#wordcloud
#positive<-subset(movie,class=="Pos")
#negative<-subset(movie,class=="Neg")
#library(wordcloud)
#wordcloud(positive$text, max.words = 50, scale=c(5,1))
#wordcloud(negative$text, max.words = 50, scale=c(5,1))


movie_freq_words<-findFreqTerms(movie_dtm_train, 5) #5번이상 사용되는 단어들
movie_freq_words

movie_freq_train<-movie_dtm_train[,movie_freq_words]
movie_freq_train
movie_freq_test<-movie_dtm_test[,movie_freq_words]
movie_freq_test

convert_counts<-function(x){
  x<-ifelse(x>0,"yes","no")
}

movie_train<-apply(movie_freq_train, MARGIN = 2, convert_counts) #margin= 2: 열단위
movie_test<-apply(movie_freq_test, MARGIN = 2, convert_counts)

library(e1071)
movie_classifier<-naiveBayes(movie_train, movie_train_label)
dim(movie_train)
table(movie_train_label)
movie_pred<-predict(movie_classifier, movie_test)



library(gmodels)
CrossTable(movie_pred, 
           movie_test_label,
           prop.t = F,
           prop.r = F,
           dnn=c("predict","actual")
           )
sum(movie_pred==movie_test_label)*100/length(movie_test_label)
