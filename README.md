DEPRECATION
-----------
We are in process of deprecating pitchfork and replacing it with effort we did
with bioconda. As a major contributor, Mengjuei would love to thank you for
your support and all the fun building this tool out from his own weekend
project.

DISCLAIMER
----------
THIS WEBSITE AND CONTENT AND ALL SITE-RELATED SERVICES, INCLUDING ANY DATA, ARE PROVIDED "AS IS," WITH ALL FAULTS, WITH NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY WARRANTIES OF MERCHANTABILITY, SATISFACTORY QUALITY, NON-INFRINGEMENT OR FITNESS FOR A PARTICULAR PURPOSE. YOU ASSUME TOTAL RESPONSIBILITY AND RISK FOR YOUR USE OF THIS SITE, ALL SITE-RELATED SERVICES, AND ANY THIRD PARTY WEBSITES OR APPLICATIONS. NO ORAL OR WRITTEN INFORMATION OR ADVICE SHALL CREATE A WARRANTY OF ANY KIND. ANY REFERENCES TO SPECIFIC PRODUCTS OR SERVICES ON THE WEBSITES DO NOT CONSTITUTE OR IMPLY A RECOMMENDATION OR ENDORSEMENT BY PACIFIC BIOSCIENCES.

Pitchfork
---------
Pitchfork is a collection of proof-of-concept building scripts for building pacbio software from the github projects using a dumb Makefile file to describe the software component dependencies. This is an unofficial, pedantic way to build software from pacbio's github projects. If you just need to access to pacbio's software distribution, and don't want to go the hard path, please ask for assistance from pacbio tech support at http://www.pacb.com/support/ .

## Here is an example how pitchfork might work for you:

    echo PREFIX=/opt/mybuild > settings.mk
    # Note: Overrides to the default reside in `.git/settings.mk`
    #           (which is symlinked to `./settings.mk`).
    make init
    make blasr                                 # if you want to build your own blasr

    # to use the build,
    bash --init-file /opt/mybuild/setup-env.sh # either to use the build in the sub-shell
    # or
    source /opt/mybuild/setup-env.sh           # to use the build in current shell


For more information, please visit the [wiki page](https://github.com/PacificBiosciences/pitchfork/wiki)
