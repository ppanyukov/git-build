FROM centos:%TAG%

# Gets the pre-requisites and git sources for later make.

RUN echo "Base dev environemnt" \
    && yum -y install \
        gcc \
        gcc-c++ \
        make \
        autoconf \
        libtool \
        automake


RUN echo "git pre-reqs as per https://git-scm.com/book/en/v2/Getting-Started-Installing-Git" \
    && yum -y install \
        curl-devel \
        expat-devel \
        gettext-devel \
        openssl-devel \
        perl-devel \
        zlib-devel

RUN echo "Additional utils" \
    && yum -y install \
        wget

ENV \
    GIT_VERSION="%GIT_VERSION%" \
    GIT_SOURCE_DIR="/git-%GIT_VERSION%"

# Get the sources
RUN echo "" \
    && cd / \
    && wget https://www.kernel.org/pub/software/scm/git/git-%GIT_VERSION%.tar.gz \
    && tar -zxvf git-%GIT_VERSION%.tar.gz \
    && rm -f git-%GIT_VERSION%.tar.gz
