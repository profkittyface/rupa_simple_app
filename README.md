## Rupa Application Deployment

## Overview
This demo application will be running on Amazon Elastic Container Service to demonstrate container based deployment inside of a cloud provider. We will be creating a service in ECS, assigning tasks to it, attaching a load balancer to the containers in the service, and viewing our result.

```
-------------------
-  Container/Task -
-------------------
         -
         -
-------------------
-  ECS Service    -
-------------------
         -
         -
-------------------
-  Public IP/LB   -
-------------------
```


### Building
The app is a NodeJS app that runs inside a docker container. To build the app, cd into the repo directory and execute a docker build with
```bash
docker build . -t rupa-simple-app
```

### Deployment
This app is deployed to ECS via a Terraform state. The state files are available in the **/terraform** directory in the repository. Applyin the terraform state is as simple as changing into the terraform directory and running
```bash
terraform apply
```

### Pushing the built container
To authenticate with ECR, get the output value from the Terraform apply, then use it in the following command.
```bash
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 613128383043.dkr.ecr.us-west-1.amazonaws.com
```
After authenticating, tag your built container with the output path.
```bash
docker tag rupa-simple-app 613128383043.dkr.ecr.us-west-1.amazonaws.com
```
And finally pushing the image to ECR.
```bash
docker push 613128383043.dkr.ecr.us-west-1.amazonaws.com/rupa-simple-app:latest
```
