## Module 7 : Introduction to Container(=Docker) and Serverless Computing in Azure



### 1) What is Container?

메모리에서 실행되고 있는 상태

#### 2) Container 구조

![](images/container.JPG)

* App을 사용하기 위해 필요
* 하드웨어 리소스를 공유
* ex) Window / Linux Container engine 보유 (VM이 사라지는 추세)

### 3) Docker 용어

* Docker Engine
* Image : Container가 실행되지 않고  Registry에 저장되는 상태
* Container : RAM, Memory에서 실행되고 있는 상태
* Docker File : 파일로 다운받고 실행하지 않은 상태
* Docker Registry : Image를 담고 있는 Container들의 저장된 장소
  * docker login 
  * docker pull : 컨테이너에 있는 이미지 다운
  * docker tag : image에 Version넣기
  * docker push : 컨테이너에 있는 이미지를 Registry 로 upload
  * docker pull or run : 컨테이너 실행 (자동으로 이미지 다운)
  * docker rmi/rm : 컨테이너 삭제(rm) , 이미지 삭제 (rmi)

### 4) Docker 생성

```bash
az group create --name 10979F0702-LabRG --location <location> # 리소스그룹 만들기


```

### 5) Docker 실행

```bash
FQDN=$(az vm show --resource-group 10979F0702-LabRG --name myDockerVM --show-details --query [fqdns] --output tsv) # Docker가 작동되는 VM에 연결

echo $FQDN

ssh student@$FQDN

docker run -d -p 80:80 --restart=always nginx

docker ps
```



### 6)  Compose file 생성

 ```bash
nano docker-compose.yml # Docker Script 
 ```

