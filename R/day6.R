#Decision Tree : C5.0

#C5.0: 다지분리가 가능하고 범주형 입력변수의 범주 수만큼 분리 가능
#      분순도의 측도로 엔트로피 지수 사용
#활용범위: 신용평가, 고객행동 평가, 제약회사, 질병 

#엔트로피:어떤 집합에 대한 무질서 정도를 측정
#정보 증가량(Information Gain): 엔트로피가 줄어드는 측정기준으로 IG 사용

#엔트로피 그래프
curve(-x*log2(x)-(1-x)*log2(1-x),
      col="red",xlab="x",ylab="entropy",lwd=4)

credit<-read.csv("Data/credit.csv")
str(credit)
summary(credit)

set.seed(123)
train_sample<-sample(1000,900)
str(train_sample)
credit_train<-credit[train_sample,]
credit_test<-credit[-train_sample,]

prop.table(table(credit_train$default))
prop.table(table(credit_test$default))

install.packages("C50")
library(C50)
credit_model<-C5.0(credit_train[-17], credit_train$default)
credit_model
summary(credit_model)

credit_pred<-predict(credit_model, credit_test)
credit_pred

library(gmodels)

CrossTable(credit_test$default,
           credit_pred,
           prop.c=FALSE,
           prop.r = FALSE,
           dnn=c("actual","predicted"))

#부스팅(Boosting): 예측력이 약한 모형들을 결합하여 강한 예측모형을 만드는 방법.

credit_boost10<-C5.0(credit_train[-17], credit_train$default, trials = 10)
credit_boost10
summary(credit_boost10)

credit_boost10_pred<-predict(credit_boost10, credit_test)
CrossTable(credit_test$default,
           credit_boost10_pred,
           prop.c=FALSE,
           prop.r = FALSE,
           dnn=c("actual","predicted"))

#Rpart
train<-read.csv("Data/train.csv")
train
test<-read.csv("Data/test.csv")
str(test)
install.packages("readr")
install.packages("rpart")
install.packages("rpart.plot")
library(readr)
library(rpart)
library(rpart.plot)
library(dplyr)
library(ggplot2)

Survived<-train$Survived
train$Survived<-NULL

dataset<-bind_rows(train,test)
str(dataset)
summary(dataset)

dataset$PassengerId[is.na(dataset$PassengerId)==TRUE] #결측값 확인
dataset$PassengerId[is.na(dataset$Fare)==TRUE] 

#passengerId가 1044인 승객의 Fare의 NA값을 Fare열의 중앙값으로 대체
dataset$Fare[dataset$PassengerId==1044]<-median(dataset$Fare,na.rm=TRUE)

#Age열의 NA값을 Age의 중앙값으로 대체
summary(dataset$Age) #NA:263

dataset$Age<-sapply(dataset$Age, FUN = function(x){
  ifelse(is.na(x),median(dataset$Age,na.rm = TRUE),x)
  })

summary(dataset$Age) #NA:0

table(dataset$Embarked)/sum(dataset$Embarked!="") 

#dataset$Embarked가  ""인 승객 id 추출
dataset$PassengerId[dataset$Embarked==""]
dataset$Embarked[c(62,830)]<-"S"

nrow(dataset) #행의 갯수
dim(dataset) #행과 열의 갯수
sum(dataset$Cabin!= "")/nrow(dataset) 
1-(sum(dataset$Cabin!= "")/nrow(dataset)) #누락값들 비율

dataset$Cabin<-substr(dataset$Cabin,1,1)
table(dataset$Cabin)
dataset$Cabin[dataset$Cabin==""]<-"H"
str(dataset$Cabin)

#각 컬럼을 factor형으로 변환
factor_vars<-c("PassengerId","Pclass","Sex","Cabin","Embarked")
dataset[factor_vars]<-lapply(dataset[factor_vars], function(x) as.factor(x))
str(dataset)

train_cleaned<-dataset[1:891,]
test_cleaned<-dataset[892:1309,]
train_cleaned$Survived<-Survived

DT<-rpart(Survived~Pclass+Sex+Embarked+Cabin, train_cleaned, method = "class")
summary(DT)

predict_dt<-predict(DT, test_cleaned, type="class")

res<-data.frame(PassengerId=test_cleaned$PassengerId, Survived=predict_dt)
write.csv(res,file="result.csv",row.names=FALSE)

#############################Practice#################################
#mushroom data로 Decision Tree 만들기
#train: 7,  test:3
#C5.0
library(C50)
mushroom<-read.csv("Data/mushrooms.csv")
set.seed(123)
mushroom<-mushroom[-17]
mush_sample<-sample(8124,5687)
train_sample_mush<-mushroom[mush_sample,]
test_sample_mush<-mushroom[-mush_sample,]
str(train_sample_mush)

mush_model<-C5.0(train_sample_mush[-1], train_sample_mush$type)
mush_predict<-predict(mush_model, test_sample_mush)
mush_predict

library(gmodels)

CrossTable(test_sample_mush$type,
           mush_predict,
           prop.c=FALSE,
           prop.r = FALSE,
           dnn=c("actual","predicted"))


#Rpart
mushroom<-read.csv("Data/mushrooms.csv")
str(mushroom) # 23개 변수, 8124 객체
summary(mushroom)
train_mushroom<-mushroom[1:5687,] #train: 70%
test_mushroom<-mushroom[5688:8124,] #test: 30%

summary(train_mushroom)

DT<-rpart(type~.,train_mushroom, method="class") #전체 변수를 독립변수로 지정
summary(DT)

predict_mush<-predict(DT, test_mushroom, type="class")
CrossTable(test_mushroom$type,
           predict_mush,
           prop.c=FALSE,
           prop.r = FALSE,
           dnn=c("actual","predicted"))
