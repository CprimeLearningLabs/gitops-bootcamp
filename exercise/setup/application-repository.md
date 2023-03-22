# Setting up an application repository

In addition to using Git to store and version the definition of what we want running in our clusters, we'll use it to develop and version our application code. This is the canonical usage of Git and one you're likely already familiar with, even if you've never heard of GitOps before.

## Create your server repository

We already have an organization in which to work, so there's no need to create another one. First, just go to the home of your organization. If you're still on the page for your infrastructure repository, the easiest way to do this is via the "breadcrumbs" navigation structure high on the page where you can just click on the link that is the name of your organization.

From the organizations home, you can click on the `Repositories` tab. You should see that there is already a repository in your organzation (that you created in the last lab and just navigated from). There is still also a green button for creating another new repository. This is what we intend to do.

Click the big, green `New repository` button.

Give your repository a name. The repository is namespaced to the organization, so it doesn't have to be broadly unique. Just call it `application`.

Make your repository public. It's mostly inconsequential for this repository, but let's just make it public.

Click Create repository on you're on your way.

## Clone your repositoy

You now have an empty repository on GitHub. You'll now create a second repository that is a copy of the one on GitHub's servers. This one will live on your disk and is the way teams typically work with Git repositories.

On the main page of your new repository, you should see a URL for cloning your repository. You can use either SSH or HTTPS. If you have questions about those protocols and which you should choose, ask your instructor. Whichever you choose, copy the URL. GitHub provides a button for this for convenience.

From your terminal, first move to a directory where you'll keep files and repositories for this course. If you followed the instructions in the last lab exactly, you're probably still there. If you did change directories into the infrastructure repository you cloned, you'll wan to return back out of it so you can create your application repository as a sibling of your infrastructure repository.

```
cd ..
```

Then, use Git to clone the repository to your machine (pasting in what you copied in place of `<the URL you just copied>`).

```
git clone <the URL you just copied>
```

You're now set up to work with your application repository, which will be the ground where the engineering happens to develop the software you'll want to deploy.
