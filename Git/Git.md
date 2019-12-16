## Git

> Git은 분산형버전관리시스템(DVCS)이다.
>
> 소스코드 형상 관리 도구로, 코드의 이력을 관리 할 수 있다.



## Git 로컬 저장소 활용하기

> git은 repository로 가각 프로젝트를 관리한다.



### 0. 기본설정

git에서 이력을 남기기 위해 작성자(author) 정보를 추가한다. 내 컴퓨터에서 최초로 한번만 설정하면 된다.

```bash
$ git config --global user.name {유저네임}
$ git config --global user.email {이메일}
$ git config --global -l
user.name=Kyeonga
user.email=kka960602@gmail.com

```



### 1. 저장소 생성

```bash
$ git init # 초기화

```



### 2. add

> 커밋 대상 파일을 staging area로 이동시킨다.
>
> 즉, 이력을 남긴 파일을 담아 놓는 것이다.



```bash
$ git add . #git폴더 추가
$ git add git.md #특정 파일만 stage
$ git add images/ #특정 폴더만 stage

$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   "\353\247\210\355\201\254\353\213\244\354\232\264 \355\231\234\354\232\251.md"
        
        
$ git commit -m 'Git 기초'
[master (root-commit) 4f80f4f] Git 기초
 1 file changed, 84 insertions(+)
 create mode 100644 "\353\247\210\355\201\254\353\213\244\354\232\264 \355\231\234\354\232\251.md"

$ git log
commit 4f80f4f94749579456d2e6cb194f61c0401de9e2 (HEAD -> master)
Author: kyeonga <kka960602@gmail.com>
Date:   Thu Dec 5 12:41:37 2019 +0900

    Git 기초

```



##  Git 원격 저장소 활용하기



### 0. 기본설정

> 원격 저장소를 생성한다. Ex) github
>
> 



### 1. 원격저장소 등록



`origin`이라는 이름으로 해당 url을 원격 저장소로 등록! 

최초에 한번만 하면 된다.



```bash
$ git remote add origin https://github.com/Kyeonga-Kim/TIL.git

$ git remote -v # 원격 저장소 목록
origin  https://github.com/edutak/TIL-a.git (fetch)
origin  https://github.com/edutak/TIL-a.git (push)
```



### 2. 원격 저장소 add -> commit -> push

앞으로 변경되는 사항이 있으면 항상 `add`, `commit` , `push` 를 진행한다. (무조건!! )

```bash
$ git add .

$ git commit -m 'Git 기초(메세지 입력)' 

$ git push -u origin master
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Delta compression using up to 4 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 1.05 KiB | 1.05 MiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To https://github.com/Kyeonga-Kim/TIL.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.

```

