# Jenkins:




## How to make fast Jenkins Server:
* Navigate to Jenkins installation directory:
    ```bash
        cd /var/lib/jenkins/
    ```
* Modify jenkins.model.JenkinsLocationConfiguration.xml file by executing below command:
    ```bash
        sudo nano jenkins.model.JenkinsLocationConfiguration.xml
    ```
    * In this file, replace the http://public-ip/8080/ to the current public-ip address http://current-public-ip:8080/
