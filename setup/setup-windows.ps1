choco install -y Microsoft-Windows-Subsystem-Linux -source WindowsFeatures

choco install -y docker-desktop
choco install -y kubernetes-helm
choco install -y kind
choco install -y git
choco install -y argocd-cli
Invoke-WebRequest https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-windows-amd64 -Outfile C:\ProgramData\chocolatey\bin\kubectl-argo-rollouts-windows-amd64.exe

refreshenv
wsl --update
