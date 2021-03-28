# windowsservercore-1803 required as it has the fonts we need in the report in order to export to PDF
FROM microsoft/iis:windowsservercore-1803

# Install features we need
RUN ["powershell.exe", "Install-WindowsFeature NET-Framework-45-ASPNET"]
RUN ["powershell.exe", "Install-WindowsFeature Web-Asp-Net45"]

# Hack in oledlg dll for crystal reports installer to work!
COPY ./System32/oledlg.dll c:/windows/System32
COPY ./SysWOW64/oledlg.dll c:/windows/SysWOW64

WORKDIR /install
COPY ./CRRuntime_64bit_13_0_30.msi .
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Start-Process -FilePath 'C:/install/CRRuntime_64bit_13_0_30.msi' -ArgumentList '/quiet', '/NoRestart', '/L*V C:/install/msi.log' -Wait; \
Remove-Item c:/install/CRRuntime_64bit_13_0_30.msi
