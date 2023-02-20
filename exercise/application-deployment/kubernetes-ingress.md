# Create a Kubernetes service to expose the application

Ingress, in a Kubernetes cluster, is a capability that enables external access to the services in the cluster.

In setting up our clusters, we installed an ingress controller based on the webserver Nginx. With such an ingress controller in place, we're able to create ingress resources in the cluster that will determine which services should respond to which requests based on the properties of a given request.

## Adding an ingress resource to expose the service

Once again, we'll update our infrastructure repository by adding a new manifest for a new resource. This time, create a file, again in the `yaml-manifests` directory, this time at this path and filename: `yaml-manifests/simple-http-server-ingress.yaml`. Put this content in to the file.

``` yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-http-server-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  rules:
    - http:
        paths:
          - path: /simple-http-server/(.*)
            pathType: Prefix
            backend:
              service:
                name: simple-http-server-service
                port:
                  number: 80
          - path: /simple-http-server
            pathType: Prefix
            backend:
              service:
                name: simple-http-server-service
                port:
                  number: 80

```

This defines an ingress resource for our application. It uses a path to distinguish it from other ingresses, like the ingress already in our cluster for ArgoCD itself. Generally, you'd probably use hostnames to distinguish ingresses in real clusters and set up DNS records to send requests for different host names to the same cluster. We could do that here and instead of using DNS records, we could use a hosts file on your machine (or a real DNS provider). If you want your instructor to say more about ingresses, path, and hosts, please ask.

To get ArgoCD to synchronize the repository and create this resource, we'll need to add this file, commit a new snapshot, and push the commit. ArgoCD will take it from there (we can trigger ArgoCD to auto-sync by clicking the refresh button rather than waiting for the polling to cause it).

Once synchronized, requests from your machine should be able to get responses from our application.

```
curl http://localhost:8080/simple-http-server/
Hello, World!
```

You've now created a resource in you cluster such that the application is exposed to the world outside the cluster (though with our local clusters, only to your local machine) via a durable ingress rather than merely via port forwarding.
