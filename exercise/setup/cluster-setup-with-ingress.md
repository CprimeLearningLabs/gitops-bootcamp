# Setting up yet another cluster

We've already gotten a start on using kind to set up clusters. We're going to do it yet again. This time, with a little something extra that will make our clusters even more useful for our purposes.

## Create a cluster with kind with ingress capability

The clusters we've created so far are useful, but we can go even further and allow traffic from our host machine to reach services in our clusters. To do this, we first need to know something about using configuration files for setting up kind clusters.

kind supports using a YAML configuration file and giving the file to kind as a parameter for cluster creation. This looks like:

```
kind create cluster --config=config.yaml
```

To create clusters via kind with which we can surface ingress and reach in-cluster services from our browser (or other processes) to use for the remaining labs, create clsuter using the config files included in this repository.

The config files are located in the `confg` subdirectory of the root of this repsoitory. With your command line context at the root of your working directory, issue these commands:

```
kind create cluster --config=config/development-cluster-with-ingress-config.yaml
kind create cluster --config=config/production-cluster-with-ingress-config.yaml
```

NOTE: If you're in a directory other than the root of your working directory for your clone of this repository, your path to these files will differ.

You should now have two clusters. We'll work with these going forward. If you'd like to destroy the clusters you created in the earlier lab, feel free to do so. We won't need them anymore. If you want help with this, ask your instructor.
