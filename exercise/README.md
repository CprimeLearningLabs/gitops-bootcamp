# Hands-On Lab Exercises

## Setting up the Tools

1. [Setting up a cluster](setup/cluster-setup.md)
1. [Accessing the cluster with kubectl](setup/cluster-access.md)
1. [Setting up an infrastructure repository](setup/infrastructure-repository.md)
1. [Setting up an application repository](setup/application-repository.md)
1. [Adding ArgoCD to the cluster](setup/argocd-setup.md)
1. [Accessing ArgoCD](setup/argocd-access.md)

## Deploying an Application

1. [Prepare a simple application to be deployed in Kubernetes](application-deployment/prepare-application.md)
1. [Build an image and push it to a registry](application-deployment/build-and-push-image.md)
1. [Create and apply a Kubernetes deployment via manifest](application-deployment/build-and-push-image.md)
1. [Create an application in ArgoCD via the web user interface and synchorinize it](application-deployment/create-argocd-application-browser.md)
1. [Create an application in ArgoCD via the command line interface and synchorinize it](application-deployment/create-argocd-application-cli.md)
1. [Create an application in ArgoCD via declarative setup and synchorinize it](application-deployment/create-argocd-application-declarative.md)
1. [Use automated synchronization](application-deployment/automated-synchronization.md)
1. [Create a Kubernetes service to expose the application](application-deployment/kubernetes-service.md)
1. [Create an ingress resource to expose the service beyond the cluster](application-deployment/kubernetes-ingress.md)
1. [Use a pull request to update the application with a simple continuous integration setup](application-deployment/pull-request.md)

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
