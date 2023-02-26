choco install -y Microsoft-Windows-Subsystem-Linux -source WindowsFeatures

Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx
rm  .\Ubuntu.appx

choco install -y docker-desktop
choco install -y kubernetes helm
choco install -y kind
choco install -y git
choco install -y argocd-cli
Invoke-WebRequest https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-windows-amd64 -Outfile C:\ProgramData\chocolatey\bin\kubectl-argo-rollouts-windows-amd64.exe
