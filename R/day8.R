#텍스트 정제를 위한 기초 학습
myvector<-c(1:6,"a")
mylist<-list(1:6,"a")

obj1<-1:4
obj2<-6:10
obj3<-list(obj1,obj2)
obj3

mylist<-list(obj1,obj2, obj3)
mylist
#벡터:[], 리스트:[[]]
mylist[[3]][1]
mylist[[3]][[1]]


#unlist: list를 벡터형식으로 리턴
#하나의 문자 형태의 객체로 합치고자 할때
mylist<-list(1:6,"a")
unlist(mylist)

name<-c("갑","을","병","정")
gender<-c(2,1,1,2)
mydata<-data.frame(name,gender)
#attr: 속성값을 저장하거나 추출할때 사용
#메타데이터: 데이터를 설명하는 데이터 ex) html의 tag속성

attr(mydata$name, "what the variable means")<-"응답자의 이름"
mydata$name

attr(mydata$gender, "what the variable means")<-"응답자의 이름"
mydata$gender

myvalues<-gender
for (i in 1:length(gender)){
  myvalues[i]<-ifelse(gender[i]==1,"남성","여성")
}
myvalues

mydata$gender.character<-attr(mydata$gender,"what the value means")
mydata$gender


#lapply 
mylist<-list(1:4, 6:10, list(1:4, 6:10))
mylist

#tapply : text data
wordlist<-c("the","is","a","the")
df1<-c(3,4,2,4)
df2<-rep(1,4) #1이 4개
tapply(df1, wordlist, length)
# a  is the 
# 1   1   2 
tapply(df1, wordlist, sum) #가중치 계산
# a  is the 
#2   4   7 

tapply(df2,wordlist, length)
tapply(df2,wordlist, sum)


#Alphabet 
letters[3]
letters[1:26]

#nchar함수: 문자수를 세는 함수
nchar("Korea")
nchar("한국")
nchar("Korea", type="bytes") 
nchar("한국", type="bytes") #한글: 2 bytes씩
nchar("Korea\t", type = "bytes") #공백: 1byte


#문장을 단어로 분리
mysentence<-"Learning R is so interesting"
myword<-strsplit(mysentence,split=" ")

strsplit(myword[[1]][5], split="") #interesting 단어를 문자 하나씩 분리
myletters<-list(rep(NA,5))
myletters

for (i in 1:5){
  myletters[i]<-strsplit(myword[[1]][i],split = "")
}
myletters

#문자 합치기
paste(myletters[[1]],collapse = "") #collapse(문자사이)=""(공백없음)

myword2<-list(rep(NA,5))
for (i in 1:5){
  myword2[i]<-paste(myletters[[i]], collapse = "")
}
myword2
paste(myword2, collapse = " ")


rwiki<-"R is a programming language and software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, surveys of data miners, and studies of scholarly literature databases show that R's popularity has increased substantially in recent years.
R is a GNU package. The source code for the R software environment is written primarily in C, Fortran, and R. R is freely available under the GNU General Public License, and pre-compiled binary versions are provided for various operating systems. While R has a command line interface, there are several graphical front-ends available."

rwikipara<-strsplit(rwiki, split="\n")
rwikisent<-strsplit(rwikipara[[1]],split="\\. ") #마침표를 기준으로 split

strsplit(rwikisent[[1]],split=" ")

rwikiword<-list(rep(NA,2))
for (i in 1:2){
  rwikiword[[i]]<-strsplit(rwikisent[[i]],split=" ")
}
rwikiword
rwikiword[[1]][[2]][3] #language 참조

#regexpr 함수: 정규표현식
#처음 등장하는 텍스트 위치 출력
mysentence<-"Learning R is so interesting"
regexpr("ing", mysentence)

mysentence
loc.begin<-as.vector(regexpr("ing", mysentence))
loc.length<-attr(regexpr("ing", mysentence),"match.length")
loc.end<-loc.begin+loc.length-1

#gregexpr함수: 패턴이 등장하는 모든 텍스트 위치 출력
gregexpr("ing",mysentence)

length(gregexpr("ing", mysentence)[[1]])
loc.begin<-as.vector(gregexpr("ing", mysentence)[[1]]) #ing 패턴이 있는 모든 시작 인덱스 번호
loc.length<-attr(gregexpr("ing", mysentence)[[1]],"match.length") #모든 패턴 길이
loc.begin
loc.length
loc.end<-loc.begin+loc.length-1

#regexec
regexec("interestin(g)", mysentence)


mysentences<-unlist(rwikisent)
regexpr("software", mysentence)

gregexpr("software", mysentence)

#변환
sub("ing","ING",mysentence) #패턴이 있는 첫번째 요소만
gsub("ing","ING",mysentence) #전체

mytemp<-regexpr("software", mysentence)
mytemp
my.begin<-as.vector(mytemp)
my.begin
mytemp[my.begin==-1]<-NA
mytemp
my.end<-my.begin+attr(mytemp, "match.length")-1
my.end

mylocs<-matrix(NA, nrow=length(my.begin),ncol=2)

colnames(mylocs)<-c("begin","end") #coloumns 이름 변경
rownames(mylocs)<-paste("sentence", 1:length(mylocs))

for (i in 1:length(my.begin)){
  mylocs[i,]<-cbind(my.begin[i],my.end[i])
}

#grep, grepl: 특정표현이 텍스트에 있는지 확인
mysentences
grep("software", mysentences) #1,2,5번 문장에서 있음
grepl("software", mysentences) #boolean형태

sent1<-rwikisent[[1]][1]
sent1
new.sent1<-gsub("R Foundation for Statistical Computing","R_Foundation_for_Statistical_Computing",sent1)
new.sent1
#sent1 단어 갯수
table(strsplit(sent1,split=" "))#각 단어별 갯수
sum(table(strsplit(sent1,split=" "))) #전체 갯수 합 #21
#new.sent1 단어갯수
sum(table(strsplit(new.sent1,split=" "))) #전체 갯수 합 #17
#단어제거
drop.sent1<-gsub("and | by | for | the","",new.sent1)
drop.sent1


mysentence
mypattern<-regexpr("ing", mysentence)
mypattern
regmatches(mysentence, mypattern, invert = TRUE)

mypattern<-gregexpr("ing", mysentence)
mypattern
regmatches(mysentence, mypattern)

regmatches(mysentence, mypattern, invert = TRUE) #ing(pattern)를 뺸 문자열 출력

strsplit(mysentence, split = "ing") #마지막""가 제거되서 출력

gsub("ing","",mysentence) #ing(pattern)를 빼고 한 문자열으로 합쳐진다.

substr(mysentence,1,20)

#ing로 끝나는 모든 단어를 검출
my2sentence<-c("Learning R is so interesting", "He is a fascinating singer")
mypattern0<-gregexpr("ing", my2sentence)
regmatches(my2sentence, mypattern0)

#ing앞에 알파벳 표현 확인
mypattern1<-gregexpr("[[:alpha:]]+(ing)", my2sentence) #Learning #interesting #sing #fascinating
regmatches(my2sentence, mypattern1)

mypattern2<-gregexpr("[[:alpha:]]+(ing)\\b", my2sentence) #ing로 끝나는 단어만 
regmatches(my2sentence, mypattern2) #Learning #interesting #fascinating

#7개문장에 모두 ing로 끝나는 영어단어 출력
mypattern3<-gregexpr("[[:alpha:]]+(ing)\\b", mysentences)  
myings<-regmatches(mysentences, mypattern3) 

#ing로 끝나는 단어를 추출하고 단어의 빈도수
table(unlist(myings))

mypattern<-gregexpr("[[:alpha:]]+(ing)\\b", tolower(mysentences)) #computing소문자로 통일
myings<-regmatches(tolower(mysentences), mypattern3) 
table(unlist(myings))

mypattern4<-gregexpr("(stat)[[:alpha:]]+", tolower(mysentences))
mystats<-regmatches(tolower(mysentences), mypattern4)
mystats
table(unlist(mystats))

mypattern<-gregexpr("[[:upper:]]", mysentences) #대문자 알파벳 갯수
my.upper<-regmatches(mysentences, mypattern)
table(unlist(my.upper))

mypattern_l<-gregexpr("[[:lower:]]", mysentences) #대문자만
my.lower<-regmatches(mysentences, mypattern_l)
table(unlist(my.lower))

mypattern_all<-gregexpr("[[:upper:]]", toupper(mysentences)) #대문자 알파벳 갯수
my.alphas<-regmatches(toupper(mysentences), mypattern_all)
mytable<-table(unlist(my.alphas))
mytable[mytable==max(mytable)] #max:A(71)

library(ggplot2)
class(mytable)
mydata<-data.frame(mytable)
ggplot(mydata, aes(x=Var1, y=Freq, fill=Var1))+
  geom_bar(stat="identity")+
  guides(fill=FALSE)+ 
  geom_hline(aes(yintercept = median(mytable)))+ #중앙값을 hline으로 지정
  xlab("알파벳")+
  ylab("빈도수")


