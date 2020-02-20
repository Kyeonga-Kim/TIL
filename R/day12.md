## Day12

### KoNLP

```R
#환경구축
install.packages("KoNLP") #따로 KoNLP패키지 다운후 R패키지 폴더에 넣어줌

library(httpuv)
install.packages("rgdal")
library(rgdal)
install.packages("geojsonio")
library(geojsonio)
install.packages("rgeos")
library(rgeos)
install.packages("Sejong")
library(Sejong)
install.packages("hash")
library(hash)
install.packages("tau")
library(tau)
install.packages("RSQLite")
library(RSQLite)

library(KoNLP)

#패키지가 잘 install됬는지 확인
sentence <- '아버지가 방에 들어가신다'
extractNoun(sentence)
```

```R
library(tm)
library(stringr)
my.text.location<-"c:/R_project/Data/ymbaek_논문"
mypaper<-VCorpus(DirSource(my.text.location))
mypaper

mykorean<-mypaper[[19]]$content
mykorean

#전처리
mytext<-str_replace_all(mykorean,"[[:lower:]]","")
mytext<-str_replace_all(mytext,"\\(","")
mytext<-str_replace_all(mytext,"\\)","")
mytext<-str_replace_all(mytext,"‘","")
mytext<-str_replace_all(mytext,"’","")
mytext<-str_replace_all(mytext," · ","")
mytext

#명사추출
noun.mytext<-extractNoun(mytext)
noun.mytext

table(noun.mytext)

#VCorpus생성
text_corpus<-VCorpus(VectorSource(noun.mytext))
inspect(text_corpus)

#DTM
dtm_tfidf<-DocumentTermMatrix(text_corpus, control = list(weighting=function(x) weightTfIdf(x, normalize = FALSE)))
inspect(dtm_tfidf)

dtm.e<-DocumentTermMatrix(text_corpus)
inspect(dtm.e)
colnames(dtm.e[,])

#tf-IDF
as.vector(as.matrix(dtm_tfidf[,]))
```

### Web Scraping(웹 스크래핑)

```R
install.packages("rvest")
library(rvest)
library(dplyr)

#문제 
#네이버, 다음, 언론사 기사 추출

#기사 추출 -> tfidf 구성 -> 상관계수

#기사 키워드 추출
#ex) 경제신문기사 -> 오늘(문서), 어제(문서).. (doc1~doc10 10일치 문서)
#corpus -> dtm -> tfidf -> cor

url_tvcast<-"https://tv.naver.com/jtbc.youth"
html_tvcast<-read_html(url_tvcast, encoding="UTF-8")
tvcast_df<-html_tvcast %>% html_nodes(".title a") %>% html_text() %>% data.frame()#class-title, tag-a

url_t<-"https://en.wikipedia.org/wiki/Student%27s_t-distribution"
html_t<-read_html(url_t, encoding="UTF-8")

html_t %>% html_nodes(".wikitable") %>% html_table()


#html_node(): 매칭된 요소 하나 추출(id검색)
#html_nodes(): 매칭된 요소 모두 추출(class, tag)
#html_children(): 하위 요소 추출
#html_children(): 태그명 추출
#html_attrs(): 속성을 추출

#단, Javascript로 된 문서는 스크래핑 불가
```

### Practice

```R
url_news<-"https://news.naver.com/main/read.nhn?mode=LSD&mid=sec&sid1=102&oid=003&aid=0009710190"
html_news<-read_html(url_news, encoding = "UTF=8")
news<-html_news %>% html_nodes("._article_body_contents")%>% html_text()

basic_url <- 'https://search.naver.com/search.naver?&where=news&query=%EB%8C%80%EA%B5%AC%20%EB%B4%89%EC%87%84&sm=tab_pge&sort=0&photo=0&field=0&reporter_article=&pd=0&ds=&de=&docid=&nso=so:r,p:all,a:all&mynews=0&start='
urls <- NULL
for(x in 0:10){
  urls[x+1] <- paste0(basic_url, x*10+1)
}
urls

html_basic<-read_html(basic_url, encoding = "UTF=8")
news<-html_basic %>% html_nodes("._article_body_contents")%>% html_text()

#데이터 전처리
news_clean<-str_replace_all(news, "\\\"","")
news_clean<-str_replace_all(news_clean, "\n|\t","")
news_clean<-str_replace_all(news_clean, "\\☞.+","")
news_clean<-str_replace_all(news_clean, "[[:lower:]]|[[:upper:]]","")
news_clean<-str_replace_all(news_clean, "\\(","")
news_clean<-str_replace_all(news_clean, "\\)","")

news_clean<-str_replace_all(news_clean, "[[:punct:]]"," ")
news_clean<-str_replace_all(news_clean, "\\=","")
news_clean<-str_replace_all(news_clean, "[[:digit:]]","")

news_noun<-extractNoun(news_clean)
news_noun
news_corpus<-VCorpus(VectorSource(news_noun))
news_corpus

#DTM
dtm.news<-DocumentTermMatrix(news_corpus)

#TFIDF
news_tfidf<-DocumentTermMatrix(news_corpus, control = list(weighting=function(x) weightTfIdf(x, normalize = FALSE))) 
news_tfidf
colnames(news_tfidf[,])
```

