# Jenkins CI/CD Pipeline for Docker and Nginx

This guide explains how to set up a Jenkins CI/CD pipeline to automate the process of pulling code from a GitHub repository, building a Docker image from a Dockerfile, pushing the image to Docker Hub, and then pulling the image from Docker Hub to run a simple Nginx-based website.

## Prerequisites

1. **Jenkins Installation**: Ensure you have Jenkins installed and running. You can download it from [Jenkins official site](https://www.jenkins.io/download/).

2. **GitHub Repository**: You should have a GitHub repository containing your Dockerfile. For this example, the repository should include the `Dockerfile` and any other necessary files for building the Docker image.

3. **Docker Installation**: Install Docker on your Jenkins server. Follow [Docker installation guide](https://docs.docker.com/get-docker/) for your operating system.

4. **Docker Hub Account**: Create a Docker Hub account if you don't already have one. You will need it to push your Docker images. [Docker Hub Signup](https://hub.docker.com/signup)

5. **Jenkins Plugins**: Install the following Jenkins plugins:
   - **Docker Pipeline**
   - **GitHub Integration**

6. **Credentials**: Set up Jenkins credentials for GitHub and Docker Hub.

   - **GitHub Credentials**: Go to **Jenkins Dashboard > Manage Jenkins > Manage Credentials** and add GitHub credentials.
   - **Docker Hub Credentials**: Go to **Jenkins Dashboard > Manage Jenkins > Manage Credentials** and add Docker Hub credentials.

## Jenkins Pipeline Setup

### 1. Create a Jenkins Pipeline Job

1. Open Jenkins and create a new pipeline job.
2. Under the **Pipeline** section, choose **Pipeline script from SCM**.
3. Set **SCM** to **Git** and provide the URL of your GitHub repository or you can also add the script manually from this repo.
4. Under **Credentials**, select the GitHub credentials you set up earlier.
5. Set **Branch Specifier** to the branch you want to build (e.g., `main`).

### 2. Add Jenkinsfile to Your GitHub Repository

Create a `Jenkinsfile` in the root of your GitHub repository with the following content:

```groovy
pipeline {
    agent any
    environment {
        // DockerHub credentials
        DOCKER_CREDENTIALS_ID = 'nensiravaliya28'
        // DockerHub repository
        DOCKER_REPO = 'nensiravaliya28/my-nginx-app'
        // GitHub credentials
        GIT_CREDENTIALS_ID = 'gtk0'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS_ID}", url: 'https://github.com/Nency-Ravaliya/Day16.git', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image and tag it with BUILD_ID
                    def image = docker.build("${DOCKER_REPO}:${env.BUILD_ID}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image with both the BUILD_ID tag and the 'latest' tag
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        def image = docker.image("${DOCKER_REPO}:${env.BUILD_ID}")
                        image.push("${env.BUILD_ID}") // Push with BUILD_ID tag
                        image.push('latest') // Optionally, also push with 'latest' tag
                    }
                }
            }
        }
        stage('Deploy Container') {
            steps {
                script {
                    sh """
                    #!/bin/bash
                    docker pull ${DOCKER_REPO}:${env.BUILD_ID}
                    docker stop my-nginx-app-container || true
                    docker rm my-nginx-app-container || true
                    docker run -d --name my-nginx-app-container -p 80:80 ${DOCKER_REPO}:${env.BUILD_ID}
                    """
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
```

Output:
- ![image](https://github.com/user-attachments/assets/ca85b2e1-fad3-4d4b-880b-974fb6a3ba7e)
- ![image](https://github.com/user-attachments/assets/aacab8f4-4e12-4992-958e-41a8ee3c938d)
- ![image](https://github.com/user-attachments/assets/24922461-8df6-43bb-9f0d-c04977753c86)
- ![image](https://github.com/user-attachments/assets/e353576f-6491-401c-955c-1108ae836db0)
- ![image](https://github.com/user-attachments/assets/d686d3e6-d804-494e-bb0a-66562d150d87)





