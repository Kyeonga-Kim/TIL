## Module 4 : Web Apps and cloud services

### 1. WordPress 만들기

> WordPress : Azure Portal에서 배포하는 웹 개발 서비스 , 따로 개발할 필요가 없음.
>
> * App name 설정 ( 설정한 이름 . azurewebsite.net )
> * Resource Group 설정
> * App Service Plan/ Location 설정 (East US 가 오류가 가장 적음)
> * Spec Picker 
>   * Dev/Test (개발환경) : F1, D1(도메인을 지원, 1GB), B1(암호화 지원, 확장가능)
>   * Production(실제 서비스) => Autoscale (자동으로 사용자에 따라 확대/축소 가능)
>   * Isolated(전용 고급 서버)
> * Database Server 설정
> * 내 URL복사후 브라우저에서 로그인후 wordpress 관리자 모드 확인
> * Visual Studio Code 설치
>
> 

### 2. Word Press 사용하기

> * Deployment Slot
>
>   서비스(Production)을 Slot 공간(서비스 복제)에 Swapping(업뎃)을 한다.
>
>   Source -> Target 을 지정해주어 Swap한다.

 