# Error Handling

We've seen successful deployment. What happens if our application fails to start up and show up as healthy?

## Create a failing image

To make an error happen, change the code of the application so that it fails to start up.

In Go, we can make the application crash with a call to the `panic` function.

In your application repository, add a line to `main.go` that causes is to crash with `panic("Unexpected exception!")`.

This will make your `main.go` look like

``` Go
func main() {
    panic("Unexpected exception!")
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, GitOps!")
    })
    http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, User!")
    })

    http.ListenAndServe(":8080", nil)
}
```

Commit this change and push it to your remote application repository. Your Action will build a new version of your container image and push it to your registry. Get the updated version tag and update the deployment in your infrastructure repository to use it.

Commit and push and either wait for ArgoCD to gee the change or refresh to cause it to happen sooner.

The sync will cause Kubernetes to create a new Replicaset for the application. The pods, though, will fail to create. ArgoCD will stay in a state of `Progressing` for a while and ultimately show as degraded. Notice, though, that the old replicaset does not go away and the application continues to work. ArgoCD will eventually show the App Health as `Degraded`.

Revert the last commit to rollback the change. This will create a commit that undoes the last change and gets back to the prior, working image.

```
git revert --no-commit HEAD
git commit -m "Revert update to rollback the failed deployment"
git push
```

Refresh and see the app go healthy again.
