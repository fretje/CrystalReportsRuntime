FROM mcr.microsoft.com/windows:1809 AS fullWindows

# Copy fonts (exclude lucon.ttf, as it already exists) and export registry entries from fullWindows image
RUN powershell -NoProfile -Command "\
Copy-Item -Path C:\Windows\Fonts -Exclude lucon.ttf -Destination c:\Fonts -Recurse; \
New-Item -ItemType Directory -Force -Path c:\registries; \
reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' c:\registries\FontsReg.reg ; \
reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink' c:\registries\FontLink.reg ; \
"

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

COPY --from=fullWindows /Fonts/ /Windows/Fonts/
COPY --from=fullWindows /registries/ ./install/

# Hack in oledlg dll for crystal reports installer to work!
COPY --from=fullWindows c:/windows/System32/oledlg.dll c:/windows/System32
COPY --from=fullWindows c:/windows/SysWOW64/oledlg.dll c:/windows/SysWOW64

# Copy in barcode fonts
COPY ./fonts c:/windows/fonts

WORKDIR /install

COPY ./install .

ENV MSI=./CRRuntime_64bit_13_0_30.msi

RUN reg import .\FontsReg.reg; \
reg import .\FontLink.reg; \
if (!(Test-Path "$env:MSI")) { Invoke-WebRequest "https://origin.softwaredownloads.sap.com/public/file/0020000000195602021" -O "$env:MSI" } \
Start-Process -FilePath "$env:MSI" -ArgumentList '/quiet', '/NoRestart', '/L*V ./cr_redist.log' -Wait; \
Remove-Item .\* -Exclude *.log;
