##  Module 2 : Microsoft Azure management tool ( CloudShell/ PowerShell/ Azure CLI)

### 1) Cloud Shell 

> Auzre Portal에서 사용할 수 있는 쉘 ( PowerShell, Bash)



### 2) Power Shell

> window에서 사용가능한 쉘
>
> * 명령어가 길다.
>
> * 복잡하다.
>
> * Powershell ISE : powershell 명령어를 스트립트화 할 수 있다.
>
>   ​                             `console창과 script창이 있음`
>
> * Powershell Module : powershell 명령어들의 집합.
>
>   ```powershell
>   get-command # 모든 명령어 모두 출력(동사-명사형태)
>   get-process 
>   get-module # 각 모듈을 조회
>   Install-Module -Name Az -AllowClobber # Azure Module설치
>   import-module Az.Accounts # Azure Module등록
>   Connect-AzAccount # Azure에 접속
>   
>   ```
>
>   ![importmoduleAZ](images/importmoduleAZ.JPG)

### 3) Azure CLI

> windows, Mac, Linux에서 사용가능한 쉘 
>
> * 명령어가 짧다.
> * 단순하다.
>
> 

