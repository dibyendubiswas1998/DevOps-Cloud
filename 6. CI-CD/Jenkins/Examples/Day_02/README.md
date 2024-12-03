# Second Jenkins Pipeline:
Simple Pipeline for Deploying the application on EC2 Instance (inside Jenkins Master Node).<br>
**Note:** I use docker-compose concepts to **re-build**, **re-run**, and **re-deploy** the application.<br>

**Steps in Jenkinsfile:**
* Use **`docker-compose down || true`** command to down all the containers.
* Use **`docker images $APP_NAME -q | xargs -r docker rmi || true`** commands for deleting all previous images for the app.
* Use **`docker-compose build`** command for build the docker image for these application.
* Use **`docker-compose up -d`** command for deploy the application on container.

## Steps:
* Create the Application,
* Create a Dockerfile,
* Write a Pipeline file **`.jenkins/Jenkinsfile`**
* Get the Credentials from DockerHub, as AccessToken,
* Install the Jenkins,
* Store the DockerHub credentials in the jenkins credentials as **dockerhub** and access as `DOCKERHUB_CREDENTIALS` and `DOCKERHUB_CREDENTIALS_USR` for username and `DOCKERHUB_CREDENTIALS_PSW` as password.
* Create a Job in Jenkins using Pipeline,
* Trigger the Pipeline when Poll SCM (after every minute),
* Mentions URL, branch, **`.jenkins/Jenkinsfile`** into Jenkins Pipeline.
