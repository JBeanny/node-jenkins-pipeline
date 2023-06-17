---
title: "Jenkins pipeline to push docker image to Dockerhub"
disqus: JBeanny
---

By: Yim Sotharoth
docs: https://hackmd.io/@JBeanny/r1pAEh5P2

# Jenkins pipeline to push docker image to Dockerhub

## Table of Contents

[TOC]

## Installation

:::info
_firstly create a node project_

```bash=
$ npm init --y
```

:::

## Create a simple server with express

> In `index.js` created a simple server like this:

```javascript!
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Hello from Metaphorlism");
});

app.listen(8081, () => {
  console.log("Server is running on port: 8080");
});
```

---

## Create Dockerfile

_Created a file called `Dockerfile`_

```dockerfile!
FROM node:16-alpine
WORKDIR /usr/src/app
RUN npm config set registry https://registry.npmjs.org/
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8081
CMD ["node","./src/server.js"]
```

## Create Jenkinsfile

> Create a file called `Jenkinsfile`

```groovy!
pipeline {
    agent any
    environment {
        registry = "jbeanny/node-jenkins-pipeline"
        registryCredential = "dockerhub-jenkins"
    }
    stages {
        stage('Building Docker Image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":1.0.$BUILD_NUMBER"
                }
            }
        }

        stage('Deploying Docker Image') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
```

:::info

```groovy!
registry = "jbeanny/node-jenkins-pipeline"
```

This line right here is where I named my docker image.

---

```groovy!
registryCredential = "dockerhub-jenkins"
```

Before being able to push the image to Dockerhub you surely need to be authenticated.

This line right here is my Dockerhub credentials.

**_Note_**

You can create this credentials in your Jenkins dashboard by going to
`Manage Jenkins` > `Credentials`

---

```groovy!
stages {
    stage('Building Docker Image') {
        steps {
            script {
                dockerImage = docker.build registry + ":1.0.$BUILD_NUMBER"
            }
        }
    }

    stage('Deploying Docker Image') {
        steps {
            script {
                docker.withRegistry('', registryCredential) {
                    dockerImage.push()
                }
            }
        }
    }
}
```

There are 2 steps in my pipeline. The first step is to build docker image and then the second one is to push image to Dockerhub.

```groovy!
dockerImage = docker.build registry + ":1.0.$BUILD_NUMBER"
```

This line in the first step is for building docker image with the tag. Example: `jbeanny/node-jenkins-pipeline:1.0.1`

```groovy!
docker.withRegistry('', registryCredential) {
    dockerImage.push()
}
```

`docker.withRegistry('', registryCredential)`

This line establishes a connection to a Docker registry using the `withRegistry` method. The first argument is an empty string '', which implies that the default Docker registry should be used. The second argument, `registryCredential`, is likely a variable that holds the authentication information (such as username and password) required to access the registry.

`dockerImage.push()`

This line pushes the Docker image to the Docker registry. The `dockerImage` object represents the image that needs to be pushed
:::

---

## Let's create the job (Jenkins task)

I assume that you have your Jenkins dashboard up and running. Therefore you can go to your Jenkins dashboard and click on the `Add Item`

![](https://hackmd.io/_uploads/rJFz3hqw3.png)

Enter your item name and select the `Multibranch Pipeline`

![](https://hackmd.io/_uploads/ryYL23cvh.png)

Here you can enter the display name and at the `Branch Sources` you can configure your git repository there then you click on `Save`

:::info
**_Note_**

Make sure that you already created your git repository and pushed your project to the repository.

If your git repository is public then you don't need to provide the authentication credentials otherwise you need to be authenticated. In this case, I created my git repository as a public since it's just a testing purpose.
:::

Then you can go into your Jenkins job and click on `Build now`

![](https://hackmd.io/_uploads/S1H6p39P2.png)

Okay, I know I failed the first try 😁

But after the build is succeeded the docker image should be already pushed to Dockerhub.

![](https://hackmd.io/_uploads/BkFIA29w3.png)

Here is my both version of docker images due to the first try failed that's why the images version is `1.0.2` and `1.0.3`

:::info
If you want us to expand this project to be able to push and merge the updated version of the project to another git branch. Please support us more. 😁😁😒
:::

---

> Project Repository : https://github.com/JBeanny/node-jenkins-pipeline

### Contact Us

- :mailbox: yimsotharoth999@gmail.com
- [GitHub](https://github.com/metaphorlism)
- [Facebook Page](https://www.facebook.com/Metaphorlism)
- [Instagram: Metaphorlism](https://www.instagram.com/metaphorlism/)
