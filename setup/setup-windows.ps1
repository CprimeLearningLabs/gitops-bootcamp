choco install -y Microsoft-Windows-Subsystem-Linux -source WindowsFeatures

Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx
rm  .\Ubuntu.appx

choco install -y docker-desktop
brew install -y kubernetes helm
brew install -y kind
brew install -y git
