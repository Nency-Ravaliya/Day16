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
3. Set **SCM** to **Git** and provide the URL of your GitHub repository.
4. Under **Credentials**, select the GitHub credentials you set up earlier.
5. Set **Branch Specifier** to the branch you want to build (e.g., `main`).

### 2. Add Jenkinsfile to Your GitHub Repository

Create a `Jenkinsfile` in the root of your GitHub repository with the following content:

```groovy
pipeline {
    agent any

    environment {
        DOCKER_REPO = 'your-dockerhub-username/your-repository'
        GITHUB_CREDENTIALS_ID = 'your-github-credentials-id'
        DOCKER_CREDENTIALS_ID = 'your-dockerhub-credentials-id'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the code from GitHub
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t ${DOCKER_REPO}:${env.BUILD_ID} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS_ID}", url: '']) {
                        // Push the Docker image to Docker Hub
                        sh 'docker push ${DOCKER_REPO}:${env.BUILD_ID}'
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh """
                    docker stop my-nginx-app-container || true
                    docker rm my-nginx-app-container || true
                    """

                    // Pull the image from Docker Hub and run it
                    sh """
                    docker pull ${DOCKER_REPO}:${env.BUILD_ID}
                    docker run -d --name my-nginx-app-container -p 80:80 ${DOCKER_REPO}:${env.BUILD_ID}
                    """
                }
            }
        }
    }
}

