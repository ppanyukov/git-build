Convenient builds of `git-lite` for centos 5, 6, and 7 from source.

The original intent is for use with VSTS build agents (see https://github.com/Microsoft/vsts-agent).
The binaries are currently used by dockerized version of the VSTS agent (see https://github.com/ppanyukov/vso-agent-docker).

Currently building these versions of git: 
- `1.8.3.1`, 
- `1.9.1`, 
- `2.8.1`, 
- `2.9.0`.

Adding new vesrions of git is trivial: just add lines to `build_all.sh`.

Adding support for other distributions (e.g. Ubuntu or Debian) should be easy too:
craft a Dockerfile template for the target OS (see `template.centos.Dockerfile`) 
and then add a line to `build_all.sh`. 


# why


**- Newer versions of git for centos**

First, there are no modern versions of git on centos 5, 6, and 7.
Depending on OS and external repository, you may get 1.7.x or 1.8.x.
Even EPEL does not seem to have git later than 1.8.x for centos 7.


**- Slimmer versions of git for centos**

The standard git RPM for centos pulls in *a lot* of stuff that 
really isn't required for 99% of the time. 

Since the intent is to use git in docker containers, keeping the size of the
images small is important.

This build removes the following:

- No Perl
- No Python
- No translations for help -- the standard RPM pulls that in.
- No man pages etc.

The only dependencies are:

- yum install libcurl zlib


**- Really simple builds that work everywhere**

The builds happen in docker containers, so there is no need to have dedicated
VMs for this, or pollute existing machines with whatever that is required
to build git.

Can build git for all target OS's on any machine whcih supports Docker.


# to build

- install docker
- clone repo
- run `build_all.sh`

The results will be in `artifacts` directory.


# releases

- the pre-built binaries are available in releases here: https://github.com/ppanyukov/git-build/releases


