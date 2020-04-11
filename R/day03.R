install.packages("rJava")
install.packages("memoise")
install.packages("KoNLP")

install.packages("ggiraphExtra") #시각화 패키지
library(ggiraphExtra)

#USArrests 데이터(내장)
USArrests
str(USArrests)
head(USArrests)
library(tibble)

crime<-rownames_to_column(USArrests, var="state") #행 인덱스를 열로 변환
crime

crime$state<-tolower(crime$state) #state 컬럼 소문자로 변경
crime

library(ggplot2)
install.packages("maps")
states_map<-map_data("state")

install.packages("mapproj")
ggChoropleth(data=crime, aes(fill=Murder, map_id=state),map=states_map)
#fill:색깔로 표현할 컬럼명, map_id: 기준 
crime

ggChoropleth(data=crime, aes(fill=Murder, map_id=state),map=states_map, interactive = T)
install.packages("stringi")
install.packages("devtools")

#github에 있는 r package 다운
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)
str(changeCode(korpop1))
library(dplyr)
korpop1<-rename(korpop1,pop="총인구_명", name="행정구역별_읍면동") 
str(changeCode(korpop1))
library(ggplot2)
library(ggiraphExtra)
ggChoropleth(data=korpop1, #지도에 표시할 데이터
             aes(fill=pop, #색깔로 나타낼 변수
                 map_id=code, #지역 기준 변수
                 tooltip=name), map=kormap1)  #지도 위에 표시할 지역명
data("korpop1")

#각 인구분포 색깔로 나타내기 => 깃허브 패키지의 오류
ggplot(korpop1, aes(map_id=code, fill="총인구 _명"))+
  geom_map(map=kormap1, colour="black", size=0.2)+
  expand_limits(x=kormap1$long, y=kormap1$lat)+
  #scale_fill_gradient(colours=c("white","orange","yellow"))+
  ggtitle("2015년 인구분포도")+
  coord_map()

#머신러닝
subject_name<-c("John","Jane","Steve")
temp<-c(37,35,33)
flu_status<-c(TRUE,FALSE, FALSE)
temp[2:3]
temp[c[TRUE, FALSE, TRUE]]

#factor: 명목형 데이터 
gender<-factor(c("M","F","M"))
gender

factor(c("A","F","C"), levels=c("F","E","D","C","B","A"), ordered= TRUE)

sb1<- list(fn=subject_name[1],temp=temp[1],flu=flu_status[1])

#stringAsFactors: 문자열 데이터를 팩터형으로 읽을 것인가 = T
df<-data.frame(sb1, stringsAsFactors = TRUE)
str(df)


#apply계열 함수 : 함수연산을 특정단위로 쉽게 할 수 있도록 지원
#for,while(소규모 반복연산)
#apply(대규모 반복연산)

#cbind
iris_num<-NULL
iris
for (x in 1:ncol(iris)){
  if(is.numeric(iris[,x]))
    iris_num<-cbind(iris_num,iris[,x]) #cbind: 열기준으로 합치기
  #print(iris[,x])
}

#sapply
iris_num<-iris[,sapply(iris,is.numeric)] #True인 열만 합치기(수치형 열=True)

iris_num<-iris[1:10,1:4]
set.seed(123) #동일한 난수 발생
idx_r<-sample(1:10,2)
idx_c<-sample(1:4,2)
idx_c
for(i in 1:2){
  iris_num[idx_r[i],idx_c[i]]<-NA
}
iris_num

#apply: 행(1) 또는 열(2) 단위 연산(margin)
#입력: 배열,매트릭스(같은 변수형)
#출력: 매트릭스 또는 벡터
apply(iris_num,1,mean) #apply(data,margin(행/열축),함수)
apply(iris_num,2,mean,na.rm=T) #NA결측값 제거 = TRUE

apply(iris_num,2,function(x){x*2+1}) #함수지정 가능 
apply(iris_num,2,function(x){x*2+1}) #함수지정 가능

#lapply: list+apply-> 실행결과가 list
#데이터프레임: 모든 변수가 벡터를 가져야한다.
#리스트:벡터,매트릭스,데이터프레임
class(apply(iris_num,2,mean,na.rm=T)) #벡터
class(lapply(iris_num,mean,na.rm=T)) #리스트

#sapply:연산결과가 vector,list(길이가 다른경우)
class(sapply(iris_num,mean,na.rm=T)) #백터
class(sapply(iris_num,mean,na.rm=T, simplify = F)) #simplify=False : lapply로 변환

#vapply: sapply+템플릿 지정
sapply(iris_num,fivenum) #fivenum: 5가지 요약 수치(최소값,1사분위수,중앙값,3사분위수,최대값)
vapply(iris_num,fivenum,c("Min"=0,"1st"=0,"Med"=0,"3st"=0,"Max"=0)) #행 인덱스 명 설정

usedcars<-read.csv("Data/usedcars.csv",stringsAsFactors = F)
str(usedcars)
summary(usedcars$year)
summary(usedcars[c("price","mileage")]) #2이상의 컬럼 

diff(range(usedcars$price)) #차이

IQR(usedcars$price) #IQR

quantile(usedcars$price) #분위수
quantile(usedcars$price, seq(from=0,to=1,by=0.1)) #분위수 지정

boxplot(usedcars$price, main="Car prices",ylab="price($)") #price열 boxplot
boxplot(usedcars$mileage, main="Car mileage",ylab="odometer") #mileage열 boxplot

hist(usedcars$price, main="Car prices",xlab="price($)") #price열 hist
hist(usedcars$mileage, main="Car mileage",xlab="odometer") #mileage열 hist

var(usedcars$price) #분산: 데이터-평균의 제곱의 합의 평균(n-1)
sd(usedcars$price) #표준편차: 분산의 제곱근(루트)

table(usedcars$year)
table(usedcars$model)

c_table<-table(usedcars$color)
round(prop.table(c_table)*100,2) #몇 프로인지 

#일변량 통계
#이변량 통계: 두변수의 관계
#다변량 통계 : 두개이상의 변수 관계
#산포도(이변량)

plot(x=usedcars$mileage,y=usedcars$price) #음의 상관관계 

usedcars$conservative<-usedcars$color %in% c("Black","Gray","Silver","White")
table(usedcars$conservative)
install.packages("gmodels")
library(gmodels)
CrossTable(x=usedcars$model, y=usedcars$conservative)


#KNN

wbcd<-read.csv("Data/wisc_bc_data.csv", stringsAsFactors = F)



wbcd
str(wbcd)
wbcd<-wbcd[-1] #1번쨰열 지우기
str(wbcd)

table(wbcd$diagnosis)
str(wbcd)

wbcd$diagnosis<-factor(wbcd$diagnosis, levels=c("B","M"), labels = c("Benign","Malignant"))
round(prop.table(table(wbcd$diagnosis))*100,1)
summary(wbcd[c("radius_mean","area_mean","smoothness_mean")])

#normalize(정규화)
#방법1) 자체 정규화 함수 만들어주기
normalize<-function(x){
  return ((x-min(x))/(max(x)-min(x)))
}
normalize(c(1,2,3,4,5))
#방법2) normalize함수 사용하기
wbcd_n<-as.data.frame(lapply(wbcd[2:31],normalize))

#train과 test데이터로 나눔
wbcd__train<-wbcd_n[1:469,]
wbcd__test<-wbcd_n[470:569,]

wbcd_train_labels<-wbcd[1:469,1]
wbcd_test_labels<-wbcd[470:569,1]
library(class)
wbcd_test_pred<-knn(wbcd__train, wbcd__test, wbcd_train_labels, k=21)

wbcd
wbcd_n
table(wbcd$diagnosis)
CrossTable(x=wbcd_test_labels, y=wbcd_test_pred, prop.chisq = FALSE)

# 표준화는 최대/최소 값이 없음 

wbcd_z<-as.data.frame(scale(wbcd[-1])) #표준화
summary(wbcd_z$area_mean)
wbcd_train<-wbcd_z[1:469,]
wbcd_test<-wbcd_z[470:569,]

wbcd_z_train_labels<-wbcd[1:469,1]
wbcd_z_test_labels<-wbcd[470:569,1]

library(class)
wbcd_z_test_pred<-knn(wbcd_train, wbcd_test, wbcd_z_train_labels, k=21)
CrossTable(x=wbcd_z_test_labels, y=wbcd_z_test_pred, prop.chisq = FALSE)
#모델 -> 테스트 -> 정확도



#iris data: 1000건
#train(700)/ test(300) => 7:3
#train(700) => train(490)/validation(210)
#iris(1:35, 51:85, 101:135)=>train, 나머지 => test
iris
str(iris)

#정규화
iris_n<-iris[-5]
iris_n<-as.data.frame(lapply(iris_n,normalize))
iris_se<-iris_n[1:35,]
iris_ve<-iris_n[51:85,]
iris_vi<-iris_n[101:135,]
iris_train<-rbind(iris_se,iris_ve,iris_vi) #iris데이터 70프로 test 데이터로 지정
iris_se_t<-iris_n[36:50,]
iris_ve_t<-iris_n[86:100,]
iris_vi_t<-iris_n[136:150,]
iris_test<-rbind(iris_se_t,iris_ve_t,iris_vi_t) #iris데이터 70프로 train 데이터로 지정
iris_test
iris_train
#종에 대한 label지정
labels<-iris[5]
iris_train_labels<-labels[c(1:35,51:85,101:135),]
iris_test_labels<-labels[c(36:50,86:100,136:150),]
iris_train_labels

#kkn(정규화)
library(class)
iris_test_pred<-knn(iris_train, iris_test, iris_train_labels, k=21)
CrossTable(x=iris_test_labels, y=iris_test_pred, prop.chisq = FALSE)

#표준화
iris_z<-as.data.frame(scale(iris[-5]))
iris_z_train<-iris_z[c(1:35,51:85,101:135),]
iris_z_test<-iris_z[c(36:50,86:100,136:150),]

#knn(표준화)
library(class)
iris_z_test_pred<-knn(iris_z_train, iris_z_test, iris_train_labels, k=13)
CrossTable(x=iris_test_labels, y=iris_z_test_pred, prop.chisq = FALSE)

#홀수 k값 21까지 출력 #K가 1,3,5,7,9,11,15,17 
for(i in 0:10){
  print(2*i+1)
  iris_test_pred<-knn(iris_train, iris_test, iris_train_labels, k=i*2+1)
  print(table(iris_test_pred, iris_test_labels))
}


