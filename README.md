# 2-Tier application Deployment 

This is a 2-tier application based on Flask app that interacts with a MySQL database. The app allows users to submit their messages, which are then stored in the database and displayed to the user on the frontend.



## Overview of the project

- we will containerize the source code present in the code repository into docker container
- These two application run in the form of docker container and the docker images is stored in dockerHub
- Finally we will deploy the application into AWS EKS cluster using kubernetes practices 


## Phase 1 : Containerization of application

- Steps for containerization

1. Clone the source code repository:

   ```
   git clone https://github.com/
   ```

2. Write `Dockerfile`

   ```
   vi Dockerfile
   ```

3. Build docker images 

   ```
   docker build -t 2-tier_flask .
   ```

4. Create custom bridge network `2-tier`

   ```
   docker network create 2-tier
   ```


5. Run the `flask` docker container
   
   ```
   docker run -d --name flask -p 5000:5000 --network 2-tier -e MYSQL_HOST=mysql -e MYSQL_DB=mydb -e MYSQL_USER=admin -e MYSQL_PASSWORD=adimn 2-tier_flask:latest
   ```
   
     
6. Run the `mysql` docker container
   
   ```
   docker run -d --name mysql -p 3306:3306 --network 2-tier -e MYSQL_DATABASE=mydb -e MYSQL_USER=admin -e MYSQL_PASSWORD=adimn -e MYSQL_ROOT_ PASSWORD=adimn mysql:5.7
   ```

7. Deploy the application using `docker-compose`
 
   ```
   docker-compose -d 
   ```

   ```
   docker-compose down 
   ```
   
   
- Visit `http://<IP>:5000/insert_sql` to insert a message directly into the `messages` table via an SQL query.


## Phase 3 : Setup EKS cluster and Deploy the Containerized application,  

 
1. Setup `AWS CLI` On your bastion host
``` shell
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update
aws configure
```


2. Setup `kubectl` on your bastion host

```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.11/2023-03-17/bin/linux/amd64/kubectl
```

```
chmod +x ./kubectl
```

```
sudo cp ./kubectl /usr/local/bin
```

```
export PATH=/usr/local/bin:$PATH
```



3. Setup `eksctl`  On your bastion host 
``` shell
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
```

```
sudo mv /tmp/eksctl /usr/local/bin
```

```
eksctl version
```


4. create a EKS cluster 

```
eksctl create cluster --name 2-tier-cluster --region ap-south-1 --node-type t2.medium --node-min=2 --node-max=2
```




5. Create and Apply manifest files to the cluster
```
kubectl apply -f flask_deployment.yml
```

```
kubectl apply -f flask_svc.yml
```


```
kubectl apply -f mysql_deployment.yml
```

```
kubectl apply -f mysql_svc.yml
```

```
kubectl apply -f mysql_secrets.yml
```

```
kubectl apply -f mysql_configmap.yml
```
























	
	


