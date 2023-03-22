# Setting up an infrastructure repository

To use GitOps, we'll want to have a Git repository that is the source of record for the way we want to deploy our application. We'll start there by creating a Git repository that can be accessed by the GitOps tooling we'll use in our clusters. To that end, we'll want to host it on a cloud Git provider. You could use any such provider. Because we'll later make use of GitHub Actions in our examples, it will be most straightforward to use GitHub.

## Create an organization

Log in to GitHub in your browser and create an organization there. You can do this by clicking on the `+` dropdown list in the top bar of the GitHub site and choosing `New organzation`. Choose the `Create a free organization` option.

Give your organzation a name. The name must be unique on GitHub. That's really our only requirement. You could use something like `<Your GitHub Username>-gitops-bootcamp`. Use your email address as the Contact email and leave the organization as belonging to your GitHub account.

Click `Next` and then click `Complete setup`.

## Create your server repository

From the organizations home, you can click on the `Repositories` tab. You should see that the new organzation does not yet have any repositories.

Click the big, green `Create a new repository` button.

Give your repository a name. The repository is namespaced to the organization, so it doesn't have to be broadly unique. Just call it `infrastructure`.

Make your repository public. This will simplify things for us later. You don't have to use a public repository do to GitOps and likely will not in real practice, but if the repository is private, you'll have to configure a token or key in ArgoCD later. Doing that is not our primary purpose in this course, so we'll get further faster by making the repositories here public.

Click Create repository on you're on your way.

## Clone your repositoy

You now have an empty repository on GitHub. You'll now create a second repository that is a copy of the one on GitHub's servers. This one will live on your disk and is the way teams typically work with Git repositories.

On the main page of your new repository, you should see a URL for cloning your repository. You can use either SSH or HTTPS. If you have questions about those protocols and which you should choose, ask your instructor. Whichever you choose, copy the URL. GitHub provides a button for this for convenience.

From your terminal, first move to a directory where you'll keep files and repositories for this course. Then, use Git to clone the repository to your machine (pasting in what you copied in place of `<the URL you just copied>`).

```
git clone <the URL you just copied>
```

You're now set up to work with your infrastructure repository, which will be the ultimate truth on matters of what should live in your clusters.
