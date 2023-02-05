# Prepare a simple application to be deployed in Kubernetes

To get started on having an application to work with, that we'll ultimately deploy and update via GitOps, we're going to have to start with some application code. To that end, we'll create a simple application that will respond to HTTP requests.

You should already have your application repository set up from a prior lab. We'll now want to work with that application repository. You'll want to use `cd` to move from your current directory context to where you have your clone of your application repository.

In the application repository, we want to set a few things up to have a working application. Among those things are application code and a Dockerfile we can use to build the application.

## Creating the application code

To get started, create a file in the root of your working directory called `main.go`. We'll use the Go programming language here because it's popular and relatively easy to follow and understand. If you don't have experience with Go, don't worry. We're not going to do enough coding with it to have any difficulty. Also, if you don't have Go installed on your machine, don't worry. You will not need to build this code directly via the installed Go SDK. This is part of the magic of containers and Docker. We'll be able to leverage a continaer with the Go SDK installed without having to install anything else (assuming you already have Docker installed).

So you don't need Go installed and you don't need any experience with Go. In fact, here is some starter code to create the first version of our application. Simply paste this code into your `main.go` file and save the file.

``` Go
package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, World!")
    })

    http.ListenAndServe(":8080", nil)
}
```

This Go file creates a simple HTTP server that will respond on the root path with the string `Hello, Worrld!`. This is a pretty simple starting point.

## Creating the Dockerfile

In order to build this code into an image we can use to create containers, we'll need to provide instructions for Docker to be able to build the code and create the runtime image via a Dockerfile.

To do this, create a file in the root of your working directory called `Dockerfile`. Note that the name of the file matters and case is significant (Docker cares about case, even if you're on Windows and the operatings system doesn't).

Put the following content into `Dockerfile`

``` Dockerfile
FROM golang:alpine AS build

WORKDIR /app
COPY *.go .

RUN go build -o webserver main.go


FROM alpine:latest

WORKDIR /app
COPY --from=build /app/webserver .

RUN ls -la

EXPOSE 8080
CMD ["./webserver"]
```

## Making a snapshot

These two files are all we'll need to have in our repository to get started. They aren't in the repository yet, though, just on disk in the working directory associated with your local repository. You'll need to introduce these files to the repository with `git add` and create a snaphot including them with `git commit`. Working with Git is a prerequisite for this course, so you likely already know how to do this. It's common for folks to have varying degrees of experience and comfort with Git, so feel free to ask your instructor more about Git and how it works.

Creating a first snapshot in your local repository can be done with

``` sh
git add main.go
git add DcokerFile
git commit -m "Add simple HTTP server and Dockerfile

to create an application to work with and enable building images with
this code that can be run locally, pushed to a registry, shared among
teams, and deployed to container runtime environments like Kubernetes"
```

NOTE: The qualities of good commit messages can be a subject heated debate. It's generally a good idea to follow [widely accepted guidelines for good commit messages](https://cbea.ms/git-commit/). If not adhering to all of that, at the very least, all commit messages should describe why a change was made and not merely state what. This is not really the subject of this course, but it's always a topic worth a word or two. Ask your instructor if you have questions about commit messages.

Now, let's send this first commit to our hosted repository. Don't worry about branches for now and just push directly to the master/main branch. We can think about Git branches and what they'll mean for our flow later. You should already have a context of having the master/main branch checked out with a tracking relationship for master/main on the origin repository such that you can synchronize your new commit with the server with

``` sh
git push
```

That's done. Now we have application code we can work with. In the next lab, we'll take this code and turn it into a container image and push it to a registry. We'll do this locally on workstations, at least for the moment.
