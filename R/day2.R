exam<-read.csv("Data/csv_exam.csv")
exam
library(dplyr)

exam %>% summarise(mean_math=mean(math))
exam %>% group_by(class) %>% summarise(mean_math=mean(math))
exam %>% group_by(class) %>% summarise(mm=mean(math), sm=sum(math), md=median(math), cnt=n())
#cnt=n옵션: 갯수  
library(ggplot2)
data(mpg)
mpg
mpg %>% group_by(manufacturer, drv) %>% summarise(mc=mean(cty)) %>% head(10)

#mpg데이터를 회사별로 그룹화, class는 suv
#tot컬럽 추가(cty+hwy 평균)
mpg
mpg %>% 
  group_by(manufacturer) %>% 
  filter(class=="suv") %>%
  mutate(tot=(cty+hwy)/2) %>% 
  summarise(mt=mean(tot)) %>%
  arrange(desc(mt)) %>% head(5)

test1<-data.frame(id=c(1,2,3,4,5),
                  final=c(70,80,90,70,80))
test2<-data.frame(id=c(1,2,3,4,5),
                  final=c(80,90,80,50,70))
total<-left_join(test1, test2, by="id")
total
name<- data.frame(class=c(1,2,3,4,5), teacher=c("kim","lee","park","choi","han"))
exam_new<-left_join(exam,name,by="class")
exam_new

test1<-data.frame(id=c(1,2,3,4,5),
                  midterm=c(70,80,90,70,80))
test2<-data.frame(id=c(1,2,3,4,5),
                  final=c(80,90,80,50,70))
ta<-bind_rows(test1,test2)
ta

exam %>% filter(english>=80)
exam %>% filter(class %in% c(1,2,5)) #반이 1,2,5반인 점수들 출력
exam %>% select(id,math)

exam %<% mutate(test=ifelse(english>=60, "pass","fail"))
exam$test<-ifelse(exam$english >=60,"pass","fail") #둘다 가능
exam

left_join(test1,test2, by="id")


#결측치 정제
df<-data.frame(sex=c("M","F",NA,"F","M"),score=c(5,4,3,5,NA))
df
table(is.na(df))
table(is.na(df$sex))
table(is.na(df$score))
mean(df$score)
df %>%filter(is.na(score))
df_nomiss <-df %>% filter(!is.na(score)) 
mean(df_nomiss$score)
df_nomiss<-df %>% filter(!is.na(score) & !is.na(sex))
df_nomiss

#결측치가 없는 값만 담긴다.
df_nomiss2<-na.omit(df)
df_nomiss2

exam %>% summarise(mm=mean(math))

df<-data.frame(sex=c(1,2,1,3,2,1),
               score=c(5,4,3,7,2,6))
table(df$sex)
table(df$score)

df$sex<-ifelse(df$sex==3, NA, df$sex)
df$score <-ifelse(df$score>5, NA, df$score)
df %>% filter(!is.na(sex) & !is.na(score)) %>% group_by(sex) %>% summarise(ms=mean(score))

boxplot(mpg$hwy)
#hwy 12보다 작거나 37보다 큰 값에 NA 삽입후 결측값 갯수 출력
mpg$hwy<-ifelse(mpg$hwy <12 | mpg$hwy>37, NA, mpg$hwy )
table(is.na(mpg$hwy))

#drv를 기준으로 그룹화 , mean_hwy 새 컬럼에 hwy의 평균, 결측값은 제외
mpg %>% group_by(drv) %>% summarise(mean_hwy=mean(hwy, na.rm=T))

table(is.na(df$score))

#점그래프
ggplot(data=mpg, aes(x=displ, y=hwy)) #ggplot 배경 설정
ggplot(data=mpg, aes(x=displ, y=hwy))+
  geom_point()+
  xlim(3,6)+
  ylim(10,30)

df_mpg<-mpg %>% 
  group_by(drv) %>%
  summarise(mean_hwy=mean(hwy))
ggplot(data=df_mpg, aes(x=drv, y=mean_hwy))+
  geom_col()

#선그래프
economics
ggplot(data=economics, aes(x=date, y=unemploy))+
  geom_line()

install.packages("foreign")
library(foreign) #spss 파일 로드
library(dplyr) #전처리
library(ggplot2) #시각화
library(readxl) #엑셀파일
raw_welfare<-read.spss("Data/Koweps_hpc10_2015_beta1.sav", to.data.frame = T) #파일을 데이타 프레임으로 읽기

welfare<-raw_welfare
welfare
str(welfare)
View(welfare)
welfare<-rename(welfare,
       sex=h10_g3,
       birth=h10_g4,
       marriage=h10_g10,
       religion=h10_g11,
       code_job=h10_eco9,
       income=p1002_8aq1,
       code_region=h10_reg7
       )
class(welfare$sex)
table(welfare$sex)

welfare$sex=ifelse(welfare$sex==9,NA,welfare$sex)
#결측값 몇개?
table(is.na(welfare$sex))

#1="male" 2="female"로 변경
welfare$sex=ifelse(welfare$sex==1,"male","female")
table(welfare$sex)
qplot(welfare$sex) #간단한 bar형태 그래프
class(welfare$income)
summary(welfare$income)

qplot(welfare$income)+ xlim(0,1000)

#이상치 결측값 처리
ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

table(is.na(welfare$income))

welfare %>% filter(!is.na(income)) %>% 
  filter(!is.na(income)) %>%
  group_by(sex) %>%
  summarise(mi=mean(income))

summary(welfare$birth)
table(is.na(welfare$birth)) #결측값 없음
welfare$birth<-ifelse(welfare$birth == 9999, NA, welfare$birth)
welfare$age<-2015-welfare$birth+1
qplot(welfare$age)

age_income<-welfare %>% 
  filter(!is.na(income)) %>%
  group_by(age) %>%
  summarise(mi=mean(income))
ggplot(data=age_income, aes(x=age, y=mi))+
  geom_line()

welfare<-welfare %>% mutate(ageg=ifelse(age<30,"young",ifelse(age<=50,"middle","old")))

welfare_income<-welfare %>%
  filter(!is.na(income)) %>%
  group_by(ageg,sex) %>%
  summarise(mi=mean(income))

ggplot(data=welfare_income, aes(x=ageg, y=mi, fill=sex)) +
  geom_col(position = "dodge")+
  scale_x_discrete(limits=c("young","middle","old"))

#성별, 연령별 월급에 대한 평균 표
sex_age<-welfare %>%
  group_by(age,sex) %>%
  filter(!is.na(income)) %>%   #na가 포함되면 결과값이 na이가 나온다.
  summarise(mi=mean(income))
ggplot(sex_age, aes(x=age, y=mi, col=sex))+geom_line()


#직업 코드별 인원수 확인

welfare$code_job

table(welfare$code_job)

library(readxl)
list_job<-read_excel("Data/Koweps_Codebook.xlsx", sheet = 2, col_names=T) #두번째 시트 오픈

welfare<-left_join(welfare,list_job, id="code_job")
welfare$job
welfare$code_job

#welfare에서 code_job이 na가 아닌 데이터에 대해 code_job,job 열을 출력
welfare %>% 
  filter(!is.na(code_job)) %>%
  select(code_job,job) #열추출

job_income<-welfare %>%
  filter(!is.na(job)&!is.na(code_job)) %>%
  group_by(job) %>% 
  summarize(mi=mean(income))

top_10<-job_income %>% 
  arrange(desc(mi))

ggplot(data=top_10,aes(x=job,y=mi))+
  geom_col()+
  coord_flip()

ggplot(data=top_10,aes(x=reorder(job,mi),y=mi))+ #reorder: 순서 재지정
  geom_col()+
  coord_flip()