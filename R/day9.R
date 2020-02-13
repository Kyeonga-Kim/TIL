install.packages("stringr")
library(stringr)
rwiki<-"R is a programming language and software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, surveys of data miners, and studies of scholarly literature databases show that R's popularity has increased substantially in recent years.
R is a GNU package. The source code for the R software environment is written primarily in C, Fortran, and R. R is freely available under the GNU General Public License, and pre-compiled binary versions are provided for various operating systems. While R has a command line interface, there are several graphical front-ends available."
str_extract(rwiki,"software environment")
str_extract_all(rwiki,"software environment")

#대문자 1개, 알파벳 0개 이상
myextract<-str_extract_all(rwiki,"[[:upper:]]{1}[[:alpha:]]{0,}")
table(myextract)


#base
str_locate(rwiki,"software environment") #단어의 처음위치, 끝 위치 
str_locate_all(rwiki,"software environment")  

#list
mylocate<-str_locate_all(rwiki, "[[:upper:]]{1}[[:alpha:]]{0,}")
mydata<-data.frame(mylocate[[1]])
mydata
mydata$myword<-myextract[[1]]
mydata
mydata$myword.length<-mydata$end-mydata$start+1
mydata

str_replace(rwiki, "software environment","software_environment")
temp<-str_replace_all(rwiki, "software environment","software_environment")
str_extract_all(temp,"software_environment")
str_extract_all(rwiki,"software_environment")

#R->R_computer.language
#C->C_computer.language
rwiki_r<-str_replace_all(rwiki, "R","R_computer.language")
rwiki_r<-str_replace_all(rwiki_r, "C","C_computer.language")
rwiki_r

#rwiki_r에서  _computer.language_표현이 붙은 부분에는 어떤 단어들이 있고
#빈도가 어떤지 출력
table(str_extract_all(rwiki_r, "[[:alpha:]]{1}_computer.language"))

#텡스트 데이터의 문단을 구분(줄바꿈)
rwikipara<-str_split(rwiki,"\n")
rwikipara

#문단별로 문장을 구분()
str_split(rwikipara, )
rwikisent<-str_split(rwikipara[[1]],"\\. ")
my2sentences<-unlist(rwikisent)[c(4,7)]
my2sentences

#각 문장의 단어수를 출력
mylength1<-length(unlist(str_split(my2sentences[1]," ")))
mylength2<-length(unlist(str_split(my2sentences[2]," ")))
mylength1;mylength2


#str_split_fixed함수
my2sentences
str_split_fixed(my2sentences," ",5)
str_split_fixed(my2sentences," ",13)

#rwikisent 문장*단어 행렬
length.sentences<-rep(NA, length(unlist(rwikisent)))

for(i in 1:length(length.sentences)){
  length.sentences[i]<-length(unlist(str_split(unlist(rwikisent)[i]," ")))
}

max.length.sentences<-max(length.sentences)
sent.word.matrix<-str_split_fixed(unlist(rwikisent)," ",max.length.sentences)
mydata<-data.frame(sent.word.matrix)


#row, columns명 바꾸기
rownames(mydata)<-paste("sent",1:length(rownames(mydata)),sep=".")
colnames(mydata)<-paste("word",1:length(colnames(mydata)),sep=".")
mydata

#R
str_count(rwiki,"R")
str_count(rwikipara,"R")
str_count(rwikipara[[1]],"R")
str_count(unlist(rwikisent),"R") #전체 문장에서 R문자 카운트


#R이라는 단어가 등장후에 stat으로 시작하는 단어가 등장하는 빈도
rwikisent
str_count(unlist(rwikisent), "R.+stat")

str_count(unlist(rwikisent), "R.+stat|R.+Stat") 
str_extract_all(unlist(rwikisent), "R.+stat|R.+Stat") 

str_count(unlist(rwikisent),"R{1}[^R]+(s|S)tat[[:alpha:]]+")
str_extract_all(unlist(rwikisent),"R{1}[^R]+(s|S)tat[[:alpha:]]+")

#substr(),str_sub()
str_sub(unlist(rwikisent[1],1,30))

#str_dup(): 문자열 복사
str_dup("software",3)
paste(rep("software",3), collapse = " ")

#글자수 세기
str_length(unlist(rwikisent))
nchar(unlist(rwikisent))

name<-c("Joe","Jack","Jenny","Jessica")
donation<-c("11111","10000","100000","11111111")

mydata<-data.frame(name,donation)

#str_pad: 문자열 정렬
#공백문자를 side="옵션"으로 이동하여 정렬
str_pad(mydata$name, width=15, side = "right")
mydata$name2<-str_pad(mydata$name, width=15, side = "both")
mydata$donation2<-str_pad(mydata$name, width=15, side = "both", pad="~")


#패딩된 공백문자를 제거
name3<-str_trim(mydata$name2, side="right")
mydata$donation2

#양쪽의 패딩(`~`)기호를 모두 제거
donation3<-str_trim(str_replace_all(mydata$donation2,"~"," "))
mydata3<-data.frame(name3,donation3)
mydata3


mytext<-c("software environment",
  "software  environment",
  "software\tenvironment")
mytext
str_split(mytext," ")

sapply(str_split(mytext," "),length) #출력결과가 벡터 
lapply(str_split(mytext," "),length) #출력결과가 리스트

mytext.nowhitespace<-str_replace_all(mytext,"[[:space:]]+"," ")
mytext.nowhitespace
sapply(str_split(mytext.nowhitespace," "),length) #출력결과가 벡터 
lapply(str_split(mytext.nowhitespace," "),length) #출력결과가 리스트


mytext<-"The 45th President of the United States, Donald Trump, states that he knows how to play trump with the former president"
myword<-str_extract_all(mytext,boundary("word"))
table(myword)
myword

myword<-str_replace(myword,"Trump","Trump_unique_")
str_replace(myword, "States","States_unique_")
table(myword)

#숫자제거
mytext<-c("He is one of statisticians agreeing that R is the No. 1 statistical software.","He is one of statisticians agreeing that R is the No. one statistical software.")
mytext2<-str_split(str_replace_all(mytext,"[[:digit:]]+[[:space:]]+","")," ")
str_c(mytext2[[1]],collapse = " ")
str_c(mytext2[[2]],collapse = " ")

#숫자 자료임을 표시
mytext3<-str_split(str_replace_all(mytext,"[[:digit:]]+[[:space:]]+","_number_")," ")
mytext3

mytext<-"Kim et al.(2020) argued that the state of"
str_split(mytext,"\\.")
#성 et al. (년도) => _reference_ :하나의 단어로 교체
mytext<-c("she is an actor", "she is the actor")

#a an the 지정한 불용어제거
mystopword<-"(\\ban )|(\\bthe )"
str_replace_all(mytext,mystopword,"")


library(tm)
length(stopwords("en"))
length(stopwords("smart"))

#어근을 동일 ex) am are is was be => be
mytext<-c("I'm a boy. You are a boy. He might be a boy")
mystemmer.func<-function(mytextobj){
  str_replace_all(mytextobj, "(am)|(are)|(is)|(was)|(were)|(be)","be")
  str_replace_all(mytextobj, "('m)|('re)|('s)"," be")
  
}
mystemmer.func(mytext)

#글자 n-gram기반 유사도
#오늘 강남에서 맛있는 스파게티를 먹었다.
#강남에서 먹었던 오늘의 스파게티는 맛있었다.

#글자 n-gram 기반 유사도 #n=2
#오늘 늘  강 강남 남에 에서 서  맛 맛있 있는 는   스 스파 파게 게티 티를 를  먹 먹었 었다 다.

install.packages("tidytext")
library(tidytext)
install.packages("tidyr")
library(tidyr)
install.packages("textdata")
library(textdata)

#감성어휘사전=>감성분석
get_sentiments("bing")

mynrc<-data.frame(get_sentiments("nrc"))
mynrc
table(mynrc$sentiment)

################################Practice######################################

#2-gram, 3-gram 유사도
text1<-"오늘 강남에서 맛있는 스파게티를 먹었다."
text1
text2<-"강남에서 먹었던 오늘의 스파게티는 맛있었다."
text2


text1<-strsplit(text1,"") #한글자씩 자르기
text2<-strsplit(text2,"")

#2-gram
for (i in 1:length(text1[[1]])-1){
  two_gram[i]<-paste(text1[[1]][i],text1[[1]][i+1],sep="")
}

for (j in 1:length(text2[[1]])-1){
  two_gram_2[j]<-paste(text2[[1]][j],text2[[1]][j+1],sep="")
}



#유사도 구하기
similarity.func<-function(i,j){
cnt=0
for (i in two_gram){
  for(j in two_gram_2){
    if(i==j){
      cnt<-cnt+1
      }
     cnt<-cnt
    }
  }
  return(cnt/length(two_gram))
  return(cnt)
}
similarity.func(two_gram,two_gram_2)

#3-gram
for (i in 1:length(text1[[1]])-2){
  three_gram[i]<-paste(text1[[1]][i],text1[[1]][i+1],text1[[1]][i+2],sep="")
}

for (i in 1:length(text2[[1]])-2){
  three_gram_2[i]<-paste(text2[[1]][i],text2[[1]][i+1],text2[[1]][i+2],sep="")
}

#유사도 구하기
similarity.func<-function(i,j){
  cnt=0
  for (i in three_gram){
    for(j in three_gram_2){
      if(i==j){
        cnt<-cnt+1
      }
      cnt<-cnt
    }
  }
  return(cnt/length(three_gram))
  return(cnt)
}
similarity.func(three_gram,three_gram_2)

read.csv("Data/IMDB Dataset.csv")

