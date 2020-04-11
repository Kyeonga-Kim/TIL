a<-1 #a에 1할당
a=2
a
b<-3
(a+b)/2

#백터생성 #c()
v1<-c(1,2,5,8,9)
v1

v2<-c(1:5)
v2

v3<-seq(1,5)
v3

v4<-seq(1,10,by=3)
v4
v4+1

#문자열 결합
s1<-"a"
s2<-"text"
s3<-"hi"
s4<-c(s1,s2,s3)
s4

#평균,최댓값,최솟값
mean(v1)
max(v1)
min(v1)

paste(s4, collapse =",")


install.packages("ggplot2")
library("ggplot2") #패키지 사용
x<-c("a","a","b","c")
qplot(x) #빈도 그래프 
mpg
qplot(data=mpg, x=hwy)

qplot(data=mpg, x=drv, y=hwy)

qplot(data=mpg, x=drv, y=hwy, geom = "line") #선그래프

qplot(data=mpg, x=drv, y=hwy, geom = "boxplot", color=drv) #상자그림

?qplot #help

#데이터프레임 만들기
eng<-c(90,80,60,70)
math<-c(70,80,50,90)

df_mid<-data.frame(eng,math)
df_mid
str(df_mid) #타입, 요소 확인

class<-c(1,1,2,2)
df_mid<-data.frame(eng,math,class)
df_mid

#열참조
df_mid$eng
mean(df_mid$eng)


df<-data.frame(eng=c(90,80,60,70),
math=c(70,80,50,90),
class=c(1,1,2,2))
df

install.packages("readxl") #xml 다운을 위해 package 설치
library(readxl)
df<-read_excel("Data/excel_exam.xlsx")
df$english

novar_df<-read_excel("Data/excel_exam_novar.xlsx", col_names = F)
novar_df

df<-read.csv("Data/csv_exam.csv")
df
str(df)

#파일생성
write.csv(df, file="Data/mydf.csv")

exam<-read.csv("Data/csv_exam.csv")
View(exam) #데이타프레임으로 표 보이기
dim(exam)
str(exam)
summary(exam)

str(mpg)

#컬럼명 변경
install.packages("dplyr")
library(dplyr)
df<-data.frame(v1=c(1,2,1), v2=c(2,3,2))
df<-rename(df, var1=v1)
df
#새 컬럼 생성
df$sum<-df$var1+df$v2
df

str(mpg)
data(mpg)
mpg
#total 컬럼 추가 = hwy+cty의 평균
mpg$total<-(mpg$hwy+mpg$cty)/2
mpg
mpg<-as.data.frame(mpg)
mpg

ifelse(mpg$total>=20,"pass","fail")
table(mpg$table)

mpg$grade<-ifelse(mpg$total>=30,"A",ifelse(mpg$total>=20,"B","C"))
mpg

#filter
#exam 에서 class가 1인것만 추출
exam<-read.csv("Data/csv_exam.csv")
exam %>% filter(class==1) %>% filter(math>=50)

#2반이면서 영어점수가 80점이상인 데이터 추출
exam %>% filter(class==2) %>% filter(english>=80)
exam %>% filter(class==2 & english>=80)

exam %>% filter(class==2 | class==3 | class==5)
exam %>% filter(class %in% c(1,3,5))

exam$math
exam %>% select(math)

#math랑 class만 빼고 추출
exam %>% select(-math, -class)

#class가 1인행에 대해 english 추출
exam %>% filter(class==1) %>% select(english)

#정렬
exam %>% arrange(class, desc(math))

#파생변수 
exam %>% mutate(total=math+english+science) %>% head

#science가 60점 이상이면 pass, 미만이면 fail 
#test열 추가
exam$test= ifelse(exam$science >=60, "Pass", "Fail")
exam
