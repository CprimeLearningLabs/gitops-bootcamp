# Create a secret

It's a well-known truth that plain-text secrets do do belong in Git repositories.

It's too easy for secrest to escape that way.

This presents a problem, though. If we're using Git to describe everything we deploy to our clusters, what should we do with secrets?

The truth is that there are several options for how to manage secrets and to make them available to the containerized workloads in your clusters.

For the purposes of these labs, instead of using a vault with CSI driver or ArgoCd plugin or an offering of a cloud provider, we'll talk about options and manually create a secret in Kubernetes. We'll then access this secret in a pod in our deployment.

## Use kubectl to create a secret

What we'll do here in this lab is not really a highly reliable way of managing secrets. We just want to have a secret in our cluster to access.

We've already had a glimpse of a Kubernetes secret in action because the ArgoCD Helm chart installation created a secret we used to access the inital password for the admin user.

With kubectl, we'll here just create a simple secret.

```
kubectl create secret generic application-secret --from-literal=sauce=teriyaki -n simple-http-server-argo-declarative
```

That's it, you've created a secret
