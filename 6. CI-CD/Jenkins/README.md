# Jenkins:
## Install Jenkins as Container:
* **`Step 1:` Create a bridge network in Docker**
    ```bash
        docker network create devops # devops is networking name
    ```
* **`Step 2:` Customize the official Jenkins Docker image, by executing the following two steps:**
    * **Create a Dockerfile with the following content::**
    ```Dockerfile
        FROM jenkins/jenkins:2.479.2-jdk17
        USER root
        RUN apt-get update && apt-get install -y lsb-release
        RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
        https://download.docker.com/linux/debian/gpg
        RUN echo "deb [arch=$(dpkg --print-architecture) \
        signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
        https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
        RUN apt-get update && apt-get install -y docker-ce-cli
        USER jenkins
        RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
    ```
    * **Build a new docker image from this Dockerfile and assign the image a meaningful name, e.g. "`myjenkins-blueocean:2.479.2-1`":**
    ```bash
        docker build -t myjenkins-blueocean:2.479.2-1 .
    ```
* **`Step 3:` Create a Docker Volume:**
    ```bash
        docker volume create jenkins-data # jenkins-data is volume name
    ```
* **`Step 4:` Run your own `myjenkins-blueocean:2.479.2-1` image as a container in Docker using the following docker run command by port mapping, using networking namespace, volume:**
    ```bash
        docker run --name jenkins-blueocean --restart=on-failure --detach \
        --network devops --env DOCKER_HOST=tcp://docker:2376 \
        --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
        --volume jenkins-data:/var/jenkins_home \
        --volume jenkins-docker-certs:/certs/client:ro \
        --publish 8080:8080 --publish 50000:50000 myjenkins-blueocean:2.479.2-1
    ```
* **`Step 5:` Accessing the Docker container:**
    ```bash
        docker exec -it jenkins-blueocean bash
    ```
* **`Step 6:` Get the Password of Jenkins:**
    ```bash
        cat /var/jenkins_home/secrets/initialAdminPassword
    ```
* **`Step 7:` Start working with Jenkins:**
    * Access the Jenkins at http://localhost:8080
    * Provide the Username and Password:
        * Username: `admin`
        * Password: `admin`


## How to make fast Jenkins Server (on Linux Machine):
* Navigate to Jenkins installation directory:
    ```bash
        cd /var/lib/jenkins/
    ```
* Modify jenkins.model.JenkinsLocationConfiguration.xml file by executing below command:
    ```bash
        sudo nano jenkins.model.JenkinsLocationConfiguration.xml
    ```
    * In this file, replace the http://public-ip/8080/ to the current public-ip address http://current-public-ip:8080/
