## Crystal Reports Runtime Docker Image

This repository is for building an image containing the Crystal Reports for Visual Studio Runtime and its dependencies.

An already built image can be found at [Docker Hub](https://hub.docker.com/r/fretje/crystalreportsruntime).  
Or pull it down with the following command:

    docker pull fretje/crystalreportsruntime:latest

The base for the image is Windows Server Core.

As this is mainly used for exporting PDF reports, fonts are needed as well. We take those from the full windows version. Additionally, some barcode fonts are installed.

Note that due to how Server 2019 handles the installation of fonts, it's still necessary to call `[gdi32.dll] AddFontResource` for each font otherwise they won't be available to the application.  
See [this link](https://stackoverflow.com/questions/54366537/adding-fonts-in-server-core-2019ltsc-container-image) for more information.  
See [this link](https://gist.github.com/fretje/9c9a81a0e30554b5797e8f5bb792f866) for how this can be done at startup for an ASP.NET MVC 5 Web Application. 

Versions:
* Windows Server Core: **2019ltsc** (1809 Build 17763)
* Crystal Reports for Visual Studio Runtime: **13.0.30**

There is also a build workflow to automate the build process using Github Actions, but unfortunately this doen't work yet, as the Github Actions runners don't have Hyper-V enabled.
