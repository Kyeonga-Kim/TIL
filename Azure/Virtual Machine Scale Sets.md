### *Virtual Machine Scale Sets

> laas 서비스 환경이며, VM은 복사 (Scale out)이 안되지만 VMSS은 가능.
>
> * Scaling
>   * Scale out (복사/늘림) 
>
> ​              기본셋팅 : 5mins 
>
> ​                 cpu > 75 (greater than) , Increase count by 1  // cpu가 75 %넘으면 vm이 1씩 증가
>
> ​		       Scale in ( 줄임)
>
> ​                 cpu < 25 (Less than , decrease count by 2  
>
> * Networking 
>
>   * VMScaleng(network security group) : 보안강화를 위한 방화벽 
>
>   `Port 80(http)를 열어주기 위해 방화벽을 반드시 해제시켜야함`
>
>   * IIS(internet Information Server) 
>
>     MS의 webserver
>
>     1. Web Server
>     2. FTP Server
>     3. SMTP Server
>
>   * Apache : Linux/Unix
>
>   * NGINX : Linux/Unix  `요즘 추세(성능/보안 좋음)`

