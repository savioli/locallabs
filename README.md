# Locallabs - Trial Task - Full Stack Developer

**Trial Task** solution using:

**Ruby On Rails 6** + **NGINX** + **PUMA** + **MySQL**


## Note
I considered but didn't use components like **Devise**, **CanCanCan**, and **Rolify**, to implement some features from scratch to demonstrate my skills.

# Usage

It's possible to start the application with **Vagrant** or with **Docker + Docker Compose**.


## With Vagrant

**Vagrant** itself will be in charge of provisioning the entire environment, being only necessary to execute the following command:

```bash
vagrant up
```

In addition to **Vagrant**, it's also necessary to have the **vagrant-docker-compose** plugin installed.
If not installed, you can install it using the following command:

```bash
vagrant plugin install vagrant-docker-compose
```

After that, the **App** will be available through **NGINX** at [http://192.168.33.100:80](http://192.168.33.100:80)

OR

Available directly through the **PUMA** at [http://192.168.33.100:3000](http://192.168.33.100:3000)


## With Docker and Docker Compose


The application is prepared to be started using **Docker + Docker Compose**. 

First, you need to run the following command:

```
docker-compose up -d --build
```

**Obs.:** Make sure that the **MySQL** container is ready to avoid connection errors.

After all containers being created is necessary to execute the following commands:

```
docker exec src rails db:create
docker exec src rails db:migrate
docker exec src rails db:seed
```

After that, the **App** will be available through **NGINX** at [http://172.20.128.1:80](http://192.168.33.100:80)

OR

And directly through the **PUMA** at [http://172.20.128.3:3000](http://172.20.128.1:3000)


## Predefined Users


**Organization**  

**name:** New York News  
**slug:** nyn  

**Chief Editor:**

**name:** Jessica Pearson  
**email:** jessica.pearson@nyn.com  
**password:** jessica.pearson

**Writers:**

**name:** Mike Ross  
**email:** mike.ross@nyn.com  
**password:** mike.ross  

**name:** Louis Litt  
**email:** louis.litt@nyn.com  
**password:** louis.litt

**name:** Harvey Specter  
**email:** harvey.specter@nyn.com  
**password:** harvey.specter  

**name:** Katrina Bennett  
**email:** katrina.bennett@nyn.com  
**password:** katrina.bennett

**name:** Rachel Zane  
**email:** rachel.zane@nyn.com  
**password:** rachel.zane  
