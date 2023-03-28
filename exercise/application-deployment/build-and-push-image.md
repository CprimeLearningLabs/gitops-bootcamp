# Build an image and push it to a registry

The last lab left us in the context of our application repository. We'll want to remain there for this one.

## Build an image

The code we created in the prior lab needs to be built in order to do any good for us. Building with Go will create a binary file that will server our application. In addition to building the binary, we want to go a step further and create a container image that executes the binary and servers our HTTP server application out of containers created from the image.

We'll do both of these things in a single effort by using the multistage Dockerfile that already exists in our repository as a result of having created it in the last lab.

To use Docker to execute the instructions in our Dockerfile, we'll use the `docker build` command. Issue this:

```
docker build -t simple-http-server:latest .
```

This command told Docker to build a new image with the name `simple-http-server` and the tag `latest` from the Dockerfile in the current directory.

You should now be able to see your image with

```
docker image ls
```

You might have a lot of noise in your list of images on your machine, but you should be able to find the `simple-http-server` image you just created.

## Check that the image works

It's good to create an image with a Dockerfile, but we want to make sure that our image is actually useful. To create a container from our image, we'll use `docker run`. We'll give it some parameters to make it easy to work with our container and to expose a port on our host machine to be able to reach into the running server in the container.

Now, issue this command:

```
docker run --rm -dp 8082:8080 --name simple-http-server simple-http-server:latest
```

You should now be able to see your newly running container with

```
docker container ls
```

You might have a lot of noise in your list of containers on your machine, but you should be able to find the `simple-http-server` image you just created.

You have also exposed the Go application we created via `docker build` on port 8082 of your workstation. You can see it in action by requesting `http://localhost:8082`.

If you leave that container running, it won't hurt anything. We're not going to do anything else with it, though, so you can get rid of it. That's as simple as deleting the container.

```
docker rm -f simple-http-server
```

## Prepare to push the image to the registry

In our prior effort to build our image, we overlooked one thing. We didn't take into consideration the registry to which we want to pushg our image in naming it. That's ok, we can now tag it with a new name and/or build it again.

The reason we need to do this is that Docker and container registries follow a convention where the name of the image should include a prefix showing the registry where it lives. To be able to push this image to a registry, we first need to follow this convention.

We'll go ahead and do `docker build` again. You might wonder about this choice, thinking it will be inefficient to build again. It turns out, though, that docker is very smart about knowing what it has already done and uses hashes of the layers of filesystem it creates and is able to reuse them.  The command below will assume you are using the GitHub Container Registry (ghcr.io). If you want to use a different registry instead, you'll have to use the URI for that registry. With GitHub Container Registry, you'll need to put the name of the user/organization scope to which you want to push the image. For our purposes, use the name of the GitHub organization you created earlier. That will look like (you can't just copy and paste this one - you need to replace `<GitHub organization>` with your GitHub organization's name)

```
docker build -t ghcr.io/<GitHub organization>/simple-http-server:latest .
```

Docker's output, this time, should happen a lot faster and you should see messages about it having used cache.

## Push the image to the registry

Having built the image with the registry-prepared name, we're almost ready to push to the registry.

If you're using a registry that doesn't require authentication, you can just push the image now, but for most registries, including the GitHub Container Registry, you'll need to authenticate first. If you use a different registry than GitHub, that registry will have documentation on how to authenticate with `docker login`. You'll want to do that. For GitHub, the first thin you need to do is generate a personal access token.

You can do this on the GitHub user interface in your browser. Login on [their website](https://github.com/). In the upper right corner, you should see the image associated with your account with a downward triangle dropdown indicator.

Click that and then click `Settings`.

There will now be a menu on the left side of the page. At the bottom, click `< > Developer settings`.

Now click `Personal access tokens` in the left menu. It will expand. Click `Tokens (classic)`.

You should now see a button saying `Generate new token` that offers a dropdown list. Click it and click `Generate new token (classic)`.

You'll now see a page where you can name your token set up what scopes it can access.

Fill in a name. It doesn't really matter what you call it, just something that will remind you of its purpose when you see it again, especially when it expires. I like to use `Workstation Registry Access`.

We'll need the token to have the `write:packages` scope. Checking this checkbox automatically also checks (and disables unchecking) the `read:packages` scope.

Feel free to also add the `delete:packages` scope. It's not intended that we'll need it in the course labs, but it can help you undo something you've pushed if you do run into a situation where you want that.

NOTE: These scopes are named for packages. GitHub also has a package registry in addition to the container registry. We'll not be concerned with the package registry in this course. You can ask your instructor about it if you want to know more. For better or worse, GitHub has created a single set of scopes that covers both registries and they call it packages.

Click the green `Generate token` button at the bottom and you have created your token.

You'll see the resulting token in your browser. Copy it now because you're not going to see it again. If you lose your token, there is no recovery (you would just need to create a new one to replace it and revoke the lost one).

Now that you have your token, you can go back to your terminal and save it into an environment variable and then use the environment variable to authenticate.

In a POSIX compliant shell (like bash or zsh), that looks like

``` sh
export CR_PAT=<YOUR_TOKEN>
echo $CR_PAT | docker login ghcr.io -u anythinghere --password-stdin
```

In Powershell, it's

``` powershell
$env:CR_PAT='<YOUR_TOKEN>'
Write-Output $env:CR_PAT | docker login ghcr.io -u anythinghere --password-stdin
```

The output should be simple:

```
anythinghere
```

or

```
Login Succeeded
```

Now you can push your image.

```
docker push ghcr.io/<GitHub organization>/simple-http-server:latest
```

If that command was successful, the image is now in a registry. In order to use that image, we'll need to do one of two things: either make the image public, or set up an image pull secret in our clusters to allow authentication to the registry. For simplicity, we'll make the image publicly accessible.

To do this, go, in your brower, to your GitHub organization. You can get there from your projects in the organization by using the origanization link in the "breadcrumbs" navigation of the site.

On the organiztion page, click on the `Settings` tab.

From the left menu, click `Packages`.

Under `Package Creation`, check the checkbox labeled `Public` to allow the organzation to publish images publicly and click `Save`.

Now, go back to the organiztion page by clicking on your organization name at the top of the page. On the organiztion page, click on the `Packages` tab.

You should now see your image listed. Click it and then click `Package settings`.

Under the scary-looking `Danger Zone` heading, you should see `Chanage package visibility`. Click the `Change visibility` button there.

Select the public radio button, key the name of the package in the confirmation textbox, and click the `I understand the consequences, change package visibility.` button.

You now have a publicly published package and we can move on to using our registry to deploy our container image to create a containerized workload in a Kubernetes cluster.
