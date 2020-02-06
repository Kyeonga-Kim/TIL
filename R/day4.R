#연관분석(장바구니 분석)

install.packages("arules")
library(arules)
#groceries<-read.csv("Data/groceries.csv")
groceries<-read.transactions("Data/groceries.csv", sep=",")
str(groceries)
summary(groceries)  
#최소지지도를 설정할때는 Summary를 해보고 각 구매 상품들의 총 갯수의 최댓값의 비율을 보고 설정
#169: 거래내역에서 전체 상품 종류 갯수
#1~32: 상품당 구매한 건수

inspect(groceries[1:5]) #각 건수당 구매한 상품 종류 

itemFrequency(groceries[,1:3]) #각 상품의 구매 빈도 비율

itemFrequencyPlot(groceries, support=0.1) #support(지지도)옵션: 0.1이상인 품목 시각화
itemFrequencyPlot(groceries, topN=20) #topN(상위)옵션: 상위 n개 출력
image(groceries[1:5])
image(sample(groceries,100)) #n개 추출한 샘플 시각화
   

   
#apriori알고리즘: 최소 지지도: 0.1 이상, 최소 신뢰도는 0.8이상, 아이템 갯수는 최대10개이하 설정
groceryRule<-apriori(groceries,parameter=list(support=0.006, confidence=0.25,minlen=2))
summary(groceryRule)
inspect(groceryRule[1:10])
inspect(sort(groceryRule, by="lift")[1:5])

berryRule<-subset(groceries, items %in% c("berries","yogurt"))
inspect(berryRule)

#csv파일로 저장
write(groceryRule, file="groceryRule.csv", sep=",")

class(groceryRule) #타입: arules

as(groceryRule, "data.frame") #arules->데이터프레임으로 변환


########################################################################################

library(arules)
data(Epub)
summary(Epub) 
#가장 많이 대여한 문서 순위, 번수
#doc_11d doc_813 doc_4c6 doc_955 doc_698 (Other) 
#    356     329     288     282     245   24393 
str(Epub)
inspect(Epub[1:100])
itemFrequency(Epub[,1:100])

itemFrequencyPlot(Epub,topN=20)
#summary에서 알수 있듯이 대여수가 가장 많은 상위 20개의 문서 시각화

ecl<-eclat(Epub, parameter = list(support=5/15729, minlen=2, maxlen=10)) 
inspect(tail(sort(ecl, by="support")))

EpubRules<-apriori(Epub, parameter = list(support=0.001, confidence=0.2, minlen=2)) #65개 rules
summary(EpubRules)
EpubRules<-inspect(sort(EpubRules, by="lift")[1:20]) #향상도 큰 것부터 20개
class(EpubRules)

install.packages("arulesViz")
install.packages("visNetwork")
install.packages("igraph")

library(arulesViz) ## 시각화에 필요
remove.packages("arulesViz")
library(visNetwork) ## 시각화 중 네트워크 표현에 필요

library(igraph) ## 시각화 결과물을 인터렉티브(움직이게) 해줌
plot(EpubRules, method="graph")

EpubRule<-as(EpubRules, "data.frame") 
write(EpubRules, file="EpubRule.csv", sep=",")
#결론 
#[1]  {doc_6e7,doc_6e8} => {doc_6e9} 0.001080806 0.8095238  454.75000 17   
#[2]  {doc_6e7,doc_6e9} => {doc_6e8} 0.001080806 0.8500000  417.80156 17   
#[3]  {doc_6e8,doc_6e9} => {doc_6e7} 0.001080806 0.8947368  402.09474 17   
#[4]  {doc_6e9}         => {doc_6e8} 0.001207960 0.6785714  333.53906 19   
#[5]  {doc_6e8}         => {doc_6e9} 0.001207960 0.5937500  333.53906 19   
#[6]  {doc_6e9}         => {doc_6e7} 0.001271537 0.7142857  321.00000 20   
#[7]  {doc_6e7}         => {doc_6e9} 0.001271537 0.5714286  321.00000 20 

#doc_6e7,doc_6e8,doc_6e9 도서들이 가장 연관성이 높다.
#{doc_6e7,doc_6e8}두 도서를 같이 빌렸을때 {doc_6e9}를 빌릴 연관성이 가장 높음.

memory.limit()

