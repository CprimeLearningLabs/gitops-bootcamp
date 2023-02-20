# Setting up a second cluster

In the earlier [Setting up a cluster lab](../setup/cluster-setup.md), you created a cluster to use for our purposes as your development environment. Now, you'll set up a second cluster to use for our purposes as your production environment. You likely have more than just a development and a production environment for real systems, but the ideas of promotion can be applied with any number of environment and we'll illustrate the principles here with just these two.

In the earlier lab, you verified that kind was installed and got familiar with it, so that won't be repeated here. If you do want to go through those steps, they are in the lab linked above.

## Create a cluster with kind to serve as our production environment

kind will take a name parameter to let you name your cluster. We can use this parameter to create more than one cluster for our purposes.

Try this by creating a second cluster with this command

``` sh
kind create cluster --name second
```

You have now created two clusters. That's something we can work with. In the next lab, we'll start accessing clusters so we can interact with them in useful ways.
