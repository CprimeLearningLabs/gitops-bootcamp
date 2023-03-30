# Use a pull request to update the application with a simple continuous integration setup

To get a better idea of what it's like to flow code changes through to environments using GitOps, we can automate continuous integration against our application so that building images on changes to the code happens without the need for manual steps.

To do this, we'll leverage GitHub Actions. This is only an example of one offering from one provider of CI/CD tooling for automation. What you use in your organization may be different, but this is an example to illustrate the principles involved.

## Grant permissions to Actions in your repository to push images to your registry

Before we can use GitHub Actions to push images from workflows, we first need to give write access to the repository running our workflows to be able to push images to the user-scoped registry we've been using. You'll do this in the GitHub web user interace.

In your browser, go to the packages tab of your organization on GitHub at (replace `<GitHub organization>` with your GitHub organization name) `https://github.com/<GitHub organization>/packages`

Here, you should see your image listed. Click it. Now click on `Package settings` on the right side of the page.

On the settings page, there's a section of `Manage Actions access`. It should be empty. Click `Add repsitory` in this section. The repository you want to add is your application repository. You should have clled it `application`. Check the checkbox next to that repository (you can filter the list down by keying part of the name if you have a lot of repositories) and click `Add repositories`.

The repository is now added, but with read access only. Change the dropdown next to `application` from `Role:Read` to say `Role:Write` (by selecting the `Write` option from the dropdown list).

## Add a workflow configuration to your repository

GitHub Actions looks for a YAML file describing what should be done for workflows for your repository. You configure it by adding files in the repository in the `.github/workflows` directory. Create a file in this directory called `image.yml`. Into this file `.github/workflows/image.yml`, put the following content (assuming your default branch is `main` - if you are using `master` or something else instead, use that branch name):

``` yaml
name: Build and push Container image

on:
  push:
    branches: [main]

env:
  IMAGE_NAME: simple-http-server
  DOCKERFILE_PATH: Dockerfile
  VERSION_NUMBER: ${{ github.run_id }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      
    steps:
      - uses: actions/checkout@v2

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v1
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v2
        with:
          context: .
          file: ${{ env.DOCKERFILE_PATH }}
          push: true
          tags: |
            ghcr.io/${{ github.repository_owner }}/${{ env.IMAGE_NAME }}:${{ env.VERSION_NUMBER }}
            ghcr.io/${{ github.repository_owner }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
            ghcr.io/${{ github.repository_owner }}/${{ env.IMAGE_NAME }}:latest
```

This will configure GitHub Actions to do, on new commits on the main branch, what we have so far done manually to create new versions of the application. It will build and push an image to the registry. It's tagging the image the same as we have before, with a version number and `latest` and also with the SHA of the commit that resulted in the image.

The version number we'll get from the GitHub Actions workflow will be significantly higher than the numbers we've used so far. That's ok. They're still just numbers.

Create a new commit with this file and push it to the GitHub Server. In the GitHub user interface in your repository, you can click on Actions and see the action run. The net result should be a new image with a new tag in your registry.

## Practice using a pull request to update the application

Now we'll create a new image version for the application in a manner more realistic than we've done so far.

In your application repository, create a new feature branch

```
git checkout -b feature/path-message
```

Change the code in `main.go` to add a new path on which to respond differently.

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
    http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, User!")
    })

    http.ListenAndServe(":8080", nil)
}
```

Make a commit on your feature branch with this updated code and push it to the server. Go to your GitHub repository and submit a pull request to merge this branch into your default branch and merge the pull request.

This sequence of actions will lead to a new commit on your default branch and trigger the workflow to run, resulting in a new version of your image.

## Get the new image into your environments

Try progressing this new image through your `development` and `production` environments without step-by-step instructions here. If you have difficulty, ask your instructor for help.
