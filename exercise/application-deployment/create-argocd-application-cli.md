# Create an application in ArgoCD via the command line interface and synchorinize it

Using the browser to create an application in ArgoCD is a good starting point and involves an easy learning curve. We can do better, though, with more repeatable tools. 

## Using ArgoCD with the command line interface to set up an application

In your system setup, you installed the ArgoCD command line tool. We'll use it here to create another application, in addition to the one we already created via the browser.

## Using ArgoCD from your browser to set up an application

The first step in using getting started with the command line tool is to make sure it's installed. It should be available in your path. 

```
argocd version
```

If you have succeeded in installation, you should see output reflecting the version of the tool itself, along with some of its dependencies. This will look something like

```
argocd: v2.6.1+3f143c9
  BuildDate: 2023-02-08T19:18:18Z
  GitCommit: 3f143c9307f99a61bf7049a2b1c7194699a7c21b
  GitTreeState: clean
  GoVersion: go1.18.10
  Compiler: gc
  Platform: linux/amd64
```

### Authenticating

LIke the web application, the ArgoCD command line interface needs you to log in.

You do this with

```
argocd login localhost:8080
```

It will ask you for your username and password. Use `admin` for the username and the password you acquired in the last lab (or that you set after you logged in) .

Reminder: if you haven't already changed it to something you can remember, you can get the initial `admin` user passwrd for ArgoCD from a secret in the cluster in the `argocd` namespaces.

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Once logged in with the ArgoCD command line interface, you're able to communicate with the Argo installation in your cluster with some straightforward commands.

For example, to see what applications already exist in the cluster, you can issue

```
argocd app list
```

You should see the single application you created using your browser in the prior lab.

Let's go ahead and create a new application now.

```
argocd app create --repo https://github.com/raelyard/argo-play.git --dest-server https://kubernetes.default.svc --dest-namespace simple-http-server-argo-cli --path yaml-manifests --sync-option CreateNamespace=true simple-http-server-argo-cli
```

If you look at the web user interface in your browser, you'll see a second application in the same state we saw as when we first created with the user interface.

- Health: Missing
- Sync status: OutOfSync

We'll see the same status with

```
argocd app list
```

As we did with the first application, we'll sync it, this time with the command line interface.

```
argocd app sync simple-http-server-argo-cli
```

The result will be the same as in the last lab. You should now have two different namespaces in your development cluster, each with a deployment, a replicaset, and a pod that are identical except for the namespace.

```
kubect get namespaces
```

should now reveal that there's a new namespace we hadn't seen before - `simple-http-server-argo-cli`. ArgoCd created the namespace when we told it to synchronize.

```
kubectl get deployment -n simple-http-server-argo-cli
```

, 

```
kubectl get replicaset -n simple-http-server-argo-cli
```

and

```
kubectl get pod -n simple-http-server-argo-cli
```

will show the same resources you see in your browser.

You can also try looking at the ArgoCD application resource with

```
kubectl get application -n argocd
```

You can see details of the application by using

```
argocd app get simple-http-server-argo-cli
```

We've now created applications with ArgoCD via both the web user interface and the command line. This lab is complete, but we'll see yet another way to do this same thing in the next lab.
