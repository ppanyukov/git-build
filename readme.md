Convenient builds of `git-light` for centos 5, 6, and 7 from source.

These builds are targeted to be used in docker containers.

# why


**- Newer versions of git for centos**

First, there are no modern versions of git on centos 5, 6, and 7.
Depending on OS and external repository, you may get 1.7.x or 1.8.x.
Even EPEL does not seem to have git later than 1.8.x for centos 7.



**- Slimmer versions of git for centos**

The standard git RPM for centos pulls in *a lot* of stuff that 
really isn't required for 99% of the time. 

This build removes the following:

- No Perl
- No Python
- No translations for help -- the standard RPM pulls that in.
- No man pages etc.

The only dependencies are:

- yum install libcurl zlib


# to use

- install docker
- clone repo
- run `build_all.sh`


# releases

- the pre-built binaries are available in releases

