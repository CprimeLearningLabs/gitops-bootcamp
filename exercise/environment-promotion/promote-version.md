# Promote a verison from development to production

In our earlier efforts in deploying our application, we didn't think about versioning and did something ill-advised. We used the `latest` tag on the container image to include in the deployment in our development cluster.

This is a bad practice and we'll stop doing it now. In order to deploy versions of our application, we're going to have to be explicit about what versions belong in what environments. That begins wit the creation of the image we'll use.

## Tag an image with a version number

Earlier, we used Docker to build and image and push it to a registry. We'll do the same now, but instead of using the ephemeral `latest` tag, we'll use a tag with an explicit version number.

For the moment, we'll do this manually.

The first step we'll need to take is to return to the application repository.

The command we used before to create the image we pushed to the registry was this:

```
docker build -t ghcr.io/<GitHub organization>/simple-http-server:latest .
```

The only thing we'll do differently now is that instead of using `latest`, we'll use a version number. Versioning strategies differ and it's worth communicating with your organization to decide on how you want to version your software, likely following something like [Semantic Versioning](https://semver.org/). This is not the topic of this course, so we'll use simple integer version numbers here, starting with zero.

To build an image for version 0 of our application, we'll use (replacing `<GitHub organization>` with your GitHub organization name):

```
docker build -t ghcr.io/<GitHub organization>/simple-http-server:0 .
```

After the build is complete, push this to your registry. with (replacing `<GitHub organization>` with your GitHub organization name) (you should still be logged in to the registry - if not, you'll need to log in):

```
docker push ghcr.io/<GitHub organization>/simple-http-server:0
```

## Update the deployment to use the versioned image

The deployment currently running in our development cluster is still set to use the ephemeral `latest` tag, which is not what we want to be able to progress version through environment promotion.

Switch your command-line context back to your infrastructure repository. Switch you Git context to check out the development branch.

```
git checkout development
```

Here, we'll want to update the deployment manifest file. Edit `yaml-manifests/simple-http-server-deployment.yaml`. Find the line that says `image: ghcr.io/<GitHub organization>/simple-http-server` and change it to (replacing `<GitHub organization>` with your GitHub organization name)

``` yaml
image: ghcr.io/<GitHub organization>/simple-http-server:0
```

The whole manifest should now look like

``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-http-server-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: simple-http-server
  template:
    metadata:
      labels:
        app: simple-http-server
    spec:
      containers:
      - name: simple-http-server
        image: ghcr.io/<GitHub organization>/simple-http-server:0
        ports:
        - containerPort: 8080
```

Commit and push this change. ArgoCD in your development cluster will synchronize and this will constitute an update to the deployment. The image is really still the same, though, so there won't be any material difference in how the application runs in the cluster.

## Promote this change to production

The last step left you in the context of your infrastructure repository. Let's update our production branch to reflect this change to now look at our version-tagged image.

First, use `git checkout` to switch to the production branch.

```
git checkout production
```

Then, do a fast-forward merge to update `production` to see what is in development and push this to your remote canonical repository.

```
git merge development
git push
```

You should see the text `Fast-forward` in the output of the `git merge development` command. This means Git didn't need to create a new commit and just moved `production` forward to point at the same commit `development` was already pointing to.

ArgoCD in the production cluster will synchronize, just like it did for development. Remember that you can use the refresh button to make it happen quickly.

## Make a material change to the application

Now that we're set to deploy versions of our application, let's create a version of the code that does something perceivably different that the version we already know.

### Change the code

To do this, we'll go to the application repository once again and just change the text returned when requrests come in to our application.

In `main.go`, just change the text returned from `Hello World!` to say `Hello GitOps!`.

The whole file will now look like this:

``` Go
package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, GitOps!")
    })

    http.ListenAndServe(":8080", nil)
}

```

### Build and push a new image

Building an updated image will look like what we've done before, but we'll use the tag `1` for the new version instead of `0`. We should also, while we're doing this, update the latest tag to make life easier for teammates that might want to use the latest version of the application on their workstations for development and testing purposes.

```
docker build -t ghcr.io/<GitHub organization>/simple-http-server:1 .
docker build -t ghcr.io/<GitHub organization>/simple-http-server:latest .
docker push ghcr.io/<GitHub organization>/simple-http-server:1
docker push ghcr.io/<GitHub organization>/simple-http-server:latest
```

The registry now has a newer version, but we've not yet done anything to use it.

### Deploy the new version to development

Deployment to development is now easy. All we need to do is update our manifest to use the updated image in our infrastructure repository.

So, first switch back to your infrastructure repository.

There, update the `yaml-manifests/simple-http-server-deployment.yaml` to use the tag for the new version. This means first chacking out the `development` branch.

```
git checkout development
```

Then changing

``` yaml
image: ghcr.io/<GitHub organization>/simple-http-server:0
```

to

``` yaml
image: ghcr.io/<GitHub organization>/simple-http-server:1
```

Followed by committing and pushing this change in a new snapshot.

```
git add yaml-manifests/simple-http-server-deployment.yaml
git commit -m "Deploy version 1 to development for testing"
git push
```

This should lead to an ArgoCD sync (after a wait or a refresh click). Once this is done, the development environment should now have the new version and production should still be on the old. This can be confirmed with the commands and matching output:

```
curl http://localhost:8080/simple-http-server
Hello, GitOps!
```

and

```
curl http://localhost/simple-http-server
Hello, World!
```

### Complete the loop by promoting to production.

Now we'll use Git to update the application in production.

```
git checkout production
git merge development
git push
```

Once again, this should be a fast forward merge. When ArgoCD syncs, the latest code will now be in place in production.
