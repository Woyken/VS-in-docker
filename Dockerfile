# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_professional.exe C:\TEMP\vs_professional.exe

# Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
RUN C:\TEMP\vs_professional.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Workload.NativeDesktop `
    --add Microsoft.VisualStudio.Component.VC.CoreIde `
    --add Microsoft.VisualStudio.Component.VC.CoreBuildTools `
    --add Microsoft.VisualStudio.Component.VC.Redist.14.Latest `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.VC.ATL `
    --add Microsoft.VisualStudio.Component.VC.ATLMFC `
    --add Microsoft.VisualStudio.Component.VC.CLI.Support `
    --add Microsoft.Component.MSBuild `
    --add Microsoft.VisualStudio.Component.NuGet.BuildTools `
    --add Microsoft.VisualStudio.Component.Roslyn.Compiler `
    --add Microsoft.Net.Component.4.7.2.SDK `
    --add Microsoft.Net.Component.4.7.2.TargetingPack `
    --add Microsoft.Net.Component.4.8.SDK `
    --add Microsoft.Net.Component.4.8.TargetingPack `
    --add Microsoft.NetCore.Component.DevelopmentTools `
    --add Microsoft.NetCore.Component.Runtime.3.1 `
    --add Microsoft.NetCore.Component.SDK `
    --add Microsoft.NetCore.Component.Web `
    --add Microsoft.VisualStudio.Component.Windows10SDK.18362 `
    --add Microsoft.VisualStudio.Component.TestTools.BuildTools `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Install Python
RUN powershell.exe -Command `
$ErrorActionPreference = 'Stop'; `
wget https://www.python.org/ftp/python/3.8.3/python-3.8.3.exe -OutFile c:\python-3.8.3.exe; `
Start-Process c:\python-3.8.3.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait; `
Remove-Item c:\python-3.8.3.exe -Force

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
