# Hands-On Lab Exercises

## Setting up the Tools

1. Setting up a cluster
1. Accessing the cluster with kubectl
1. Setting up an infrastructure repository
1. Setting up an application repository
1. Adding ArgoCD to the cluster
1. Accessing ArgoCD

## Deploying an Application

1. Prepare a simple application to be deployed in Kubernetes
1. Build an image and push it to a registry
1. Create and apply a Kubernetes deployment via manifest
1. Create an application in ArgoCD via the web user interface and synchorinize it
1. Create an application in ArgoCD via the command line interface and synchorinize it
1. Create an application in ArgoCD via declarative setup and synchorinize it
1. Use automated synchronization
1. Create a Kubernetes service to expose the application
1. Create an ingress resource to expose the service beyond the cluster
1. Use a pull request to update the application with a simple continuous integration setup

## Promoting Changes Through Different Environments

1. Setting up a second cluster
1. Register the cluster in ArgoCD
1. Promote a verison from development to production
1. Blue/Green deployment
1. Canary Release
1. Handling an error

##  Security in GitOps

1. Create a secret
1. Access a secret from the running application
