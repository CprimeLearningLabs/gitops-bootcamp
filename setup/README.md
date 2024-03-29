# Workstation Setup For Students and Instructors

## Prerequisites

### Tools

To follow the course material and do the lab exercises, having the following tools installed will be necessary. This should be done before the start of the course. See `Installation` below for links to scripts to aid in this setup.

- A working Docker installation
    - Docker Desktop (on Mac or Windows)
    - Docker (on Linux)
- kubectl (installed automatically with Docker Desktop on Mac or Windows)
- Helm
- kind
- Git
- argocd (the ArgoCD command-line interface)
- argo-rollouts plugin for kubectl

### Clusters and In-Cluster Resources

During the course labs, we'll set up a cluster to use ArgoCD to do pull-based continuous delivery/deployment

## Installation

### Tools Setup

#### On Mac

[Homebrew](https://brew.sh/) is the most straightforward way to install software on MacOS. Homebrew itself can be installed with:

``` sh
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

You can confirm that Homebrew is installed and working with: `brew --version`

With a working Homebrew installation in place, there is a script provided here to use Homebrew to install the tools we'll use in the labs.

```
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/CprimeLearningLabs/gitops-bootcamp/main/setup/setup-mac.sh)"
```

#### On Windows

[Chocolatey](https://chocolatey.org/) is the most straightforward way to install software on Windows. Chocolatey itself can be installed from Powershell, running as administrator, with:

``` powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

(Alternatively, [Chocolatey can also be installed in a non-administrator mode.(https://docs.chocolatey.org/en-us/choco/setup#non-administrative-install)])

You can confirm that Chocolatey is installed and working with: `choco --version`

With a working Chocolatey installation in place, there is a script provided here to use Chocolatey to install the tools we'll use in the labs.

``` powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/CprimeLearningLabs/gitops-bootcamp/main/setup/setup-windows.ps1'))
```

Having executed this script, you'll be set up to use Windows and use these tools on Windows.

Docker Desktop will likely not just start up until you reboot your machine, so go ahead and do that now.

``` powershell
Restart-Computer
```

When your machine comes back up, Docker Desktop may or may not start automatically. You can go ahead and start it however you prefer to start applications on Windows, such as pressing the Windows key and then starting to type `Docker` and selecting it when it appears. One Docker Desktop is running, you'll be ready to proceed with verifying the tools are installed below.

#### On Linux

[There are multiple options for setting up Docker on Linux](https://docs.docker.com/engine/install/). Rather than giving prescriptive advice here, it will be left as an exercise for the Linux user to set up Docker in a working state.

With a working Docker installation in place, there is a script provided here to use apt to install the other tools we'll use in the 
labs on Debian-derived distrutions, including Ubuntu.

```
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/CprimeLearningLabs/gitops-bootcamp/main/setup/setup-ubuntu.sh)"
```

For other distributions, it will be left as an exercise for the reader to get the tools installed and in a working state.

### Verifying Tools Setup

Regardless of the operating system of your workstation, you can verify that you have everything set up by executing the following commands in the shell of your choice. The exit code of the last issued command can be checked in POSIX-compatible shells with `echo $?` and in Powershell with `Write-Host $LASTEXITCODE`.

#### Docker

Verify Docker with:

```
docker version
```

The expected output should show you information about both the installed Docker client and server and return a 0 exit code.

#### kubectl

Verify kubectl with:

```
kubectl version
```

The expected output should show you information about both the installed kubectl client and, if you have a cluster context set up, the cluster Kubernetes version. If you do have a context set up, it will return a 0 exit code. If there is no context set up, it will return a 1 exit code because of failure to talk to the cluster, but this is ok because you haven't set up a context yet.

#### Helm

Verify helm with:

```
helm version
```

The expected output should show you information about the installed Helm client and return a 0 exit code.

#### kind

Verify Docker with:

```
kind version
```

The expected output should show you information about the installed kind executable and return a 0 exit code.

#### Git

Verify Git with:

```
git version
```

The expected output should show you information about the installed Git executable and return a 0 exit code.

#### argocd

Verify the ArgoCD command-line interface (argocd) with:

```
argocd
```

The expected output should show you help information for the ArgoCD command-line tool and return a 0 exit code.

#### argo-rollouts plugin for kubectl

Verify the argo-rollouts plugin for kubectl with:

On Linux or Mac, you can use the plugin with kubectl as it was intended:

```
kubectl argo rollouts --help
```

On Windows, you'll get the same result, but will instead need to use the executable you downloaded directly:

```
kubectl-argo-rollouts-windows-amd64.exe --help
```

The expected output should show you help information for the argo-rollouts plugin for kubectl and return a 0 exit code.

## What's Next

If all of the above checks have been verified, you have installed the prerequisite tools. We'll create clusters and install resources into clusters using these tools in the course itself. We'll then use our local tools and cluster resources to create software and deploy in using GitOps. You're now ready to proceed.
