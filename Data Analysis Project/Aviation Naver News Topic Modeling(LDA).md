# Data Analysis Project

## 항공 뉴스 기사 토픽 모델링(LDA)  및 항공 운항 현황 비교 분석

### Part.1 프로젝트 수행 배경 및 목적

현재 중심 이슈인 "코로나19" 가 크게 영향을 미치는 산업이 항공산업.

과연 현재 항공관련 뉴스 기사에 관한 토픽을 가진 기사가 얼마나 많을까? 또한 항공운항 현황에 어떠한 영향을 미치고 있는가"의 물음 가지고 프로젝트를 진행하였습니다. 

"KIS(한국신용평가) 당사는 스페셜 리포트를 통해 코로나 19확산으로 부터 가장 직접적이고 즉각적인 영향을 받는 주요산업은 항공산업이다. 중국과의 밀접한 경제관계 및 인적 교류 상태를 감안할때, 부정적인 파급효과가 불가피하다."라고 설명하였다.

![](C:\Users\student\Desktop\TIL\images\1.jpg)

![](C:\Users\student\Desktop\TIL\images\2.jpg)

[출처: KIS 한국신용평가 Special Report ]

이러한 근거를 바탕으로 다음과 같은 목적을 가지고 프로젝트를 진행하였습니다.

-과연 현재 항공관련 뉴스기사에 코로나 관한 토픽을 가진 기사가 얼마나 많은가.

-항공운항현황에 어떠한 영향을 미치고 있는가.



### Part.2 프로젝트 구성

#### 1단계: 데이터 수집

* Beautifulsoup을 이용한 Web Crawler제작
* Web Crawler를 이용한 Never News Text Data 수집
* Airportal의 항공운항통계 open data 수집

#### 2단계: 데이터 전처리

* 한글을 제외한 문자 제거(특수문자, 영문, 숫자등)
* 불필요한 문자 제거
* 공백제거
* Stopword(불용어) 제거
* Tokenization(형태소 분석): 명사추출(Mecab모듈 사용)

#### 3단계: 데이터 탐색

* 시기별(1주 단위) 뉴스기사의 주요 단어 도출 및 시각화
* Gensim 토픽 모델링 (LDA) : 시기별 뉴스기사의 주요 토픽 찾기 및 시각화
* 항공운항현황 데이터 탐색 및 시각화



### Part.3  Topic Modeling (LDA) 개념적 배경

토픽 모델링이란 문서의 집합에서 토픽을 찾아내는 프로세스

K개의 토픽을 
