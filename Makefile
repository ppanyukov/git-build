################################################################################
# Makefile for building git-lite (really min dependencies) on
# various centos versions. Requires docker.
#
# To build:
#	standard: make git
#	for centos 5: make git OS_TAG=5
# 	for centos 6: make git OS_TAG=6
#
#	git v. 1.9.1 on centos 6: make git GIT_VERSION=1.9.1 OS_TAG=5
#
# To clean:
#	make clean
#
# To install:
#	- yum install libcurl zlib
#	- mv *.tar.gz /
#	- tar -zxvf /*.tar.gz
#	- ln -s /usr/git/git-light-2.8.1/bin/git /usr/local/bin/git
#
#	- (optional): yum install less openssh-clients rsync
#
#
# This build excludes the usual bloatware, specifically we build with flags:
# 	APP_BUILD_FLAGS += NO_GETTEXT=YesPlease 
# 	APP_BUILD_FLAGS += NO_PERL=YesPlease 
# 	APP_BUILD_FLAGS += NO_PYTHON=YesPlease 
# 	APP_BUILD_FLAGS += NO_TCLTK=YesPlease 
# 	APP_BUILD_FLAGS += NO_CROSS_DIRECTORY_HARDLINKS=YesPlease 
# 	APP_BUILD_FLAGS += NO_INSTALL_HARDLINKS=YesPlease 
# 	APP_BUILD_FLAGS += NO_SVN_TESTS=YesPlease
#
# The process of building is along these lines:
#	- generate Dockerfile from the template
#	- build docker image from generated Dockerfile
#	- generate make.sh script from template
#	- run make.sh from within the built image
#	- artifacts dir will have the final tar.gz
#
################################################################################

APP_NAME := git-lite
OS := centos
OS_TAG := 7
GIT_VERSION := 2.8.1


# Keep all files there
WORKDIR := _work/
ARTIFACTS := artifacts/

# e.g. git-centos-centos7-2.8.1
BASE_FILE_NAME := $(APP_NAME)-$(OS)-$(OS_TAG)-$(GIT_VERSION)

# Turn the template into real docker file.
DOCKER_FILE_TEMPLATE := template.$(OS).Dockerfile
TARGET_DOCKER_FILE := $(WORKDIR)$(BASE_FILE_NAME).Dockerfile

$(TARGET_DOCKER_FILE): $(DOCKER_FILE_TEMPLATE)
	mkdir -p $(WORKDIR)
	sed \
		-e 's/%TAG%/$(OS_TAG)'/g \
		-e 's/%GIT_VERSION%/$(GIT_VERSION)'/g \
		$< > $@



# Create docker image from docker file
TARGET_IMAGE_FILE := $(WORKDIR)$(BASE_FILE_NAME).image
DOCKER_IMAGE_TAG := build:$(BASE_FILE_NAME)

$(TARGET_IMAGE_FILE): $(TARGET_DOCKER_FILE)
	echo Building git version $(GIT_VERSION) for $(DOCKER_IMAGE_TAG)
	mkdir -p $(WORKDIR)
	docker build \
		--tag $(DOCKER_IMAGE_TAG) \
		-f $< \
		.
	echo "$(DOCKER_IMAGE_TAG)" > $@



# Generate make script to be run within the container
# to build git.
#
# With these settings:
#	- will end up in /usr/git/git-lite-2.8.1
#	- tar is git-lite-2.8.1-centos-7.tar.gz
#	- the contents of the tar will have /usr/git/git-lite-2.8.1 paths
APP_SOURCE_DIR := /git-$(GIT_VERSION)
APP_INSTALL_LOCATION := /usr/git
APP_INSTALL_NAME := $(APP_NAME)-${GIT_VERSION}
APP_INSTALL_DIR := $(APP_INSTALL_LOCATION)/$(APP_INSTALL_NAME)
APP_TAR_NAME := $(APP_INSTALL_NAME).$(OS)-$(OS_TAG).tar.gz
APP_TAR_LOCATION := /$(ARTIFACTS)

APP_BUILD_FLAGS += NO_GETTEXT=YesPlease 
APP_BUILD_FLAGS += NO_GETTEXT=YesPlease 
APP_BUILD_FLAGS += NO_PERL=YesPlease 
APP_BUILD_FLAGS += NO_PYTHON=YesPlease 
APP_BUILD_FLAGS += NO_TCLTK=YesPlease 
APP_BUILD_FLAGS += NO_CROSS_DIRECTORY_HARDLINKS=YesPlease 
APP_BUILD_FLAGS += NO_INSTALL_HARDLINKS=YesPlease 
APP_BUILD_FLAGS += NO_SVN_TESTS=YesPlease


MAKE_FILE_TEMPLATE := template.make.sh
TARGET_MAKE_FILE := $(WORKDIR)$(BASE_FILE_NAME).make.sh
$(TARGET_MAKE_FILE): $(MAKE_FILE_TEMPLATE)
	mkdir -p $(WORKDIR)
	sed \
		-e 's|%APP_SOURCE_DIR%|$(APP_SOURCE_DIR)|g' \
		-e 's|%APP_INSTALL_LOCATION%|$(APP_INSTALL_LOCATION)|g' \
		-e 's|%APP_INSTALL_NAME%|$(APP_INSTALL_NAME)|g' \
		-e 's|%APP_INSTALL_DIR%|$(APP_INSTALL_DIR)|g' \
		-e 's|%APP_TAR_NAME%|$(APP_TAR_NAME)|g' \
		-e 's|%APP_TAR_LOCATION%|$(APP_TAR_LOCATION)|g' \
		-e 's|%APP_BUILD_FLAGS%|$(APP_BUILD_FLAGS)|g' \
		$< > $@.tmp
	chmod u+x $@.tmp
	mv $@.tmp $@


# Build final tar.gz within container using genrated make script
APP_TAR_ON_HOST := $(ARTIFACTS)$(APP_TAR_NAME)

$(APP_TAR_ON_HOST): $(TARGET_MAKE_FILE) $(TARGET_IMAGE_FILE)
	@echo TARGET_MAKE_FILE: $(TARGET_MAKE_FILE)
	@echo APP_TAR_ON_HOST: $(APP_TAR_ON_HOST)
	@echo APP_BUILD_FLAGS: $(APP_BUILD_FLAGS)

	docker run \
	    -it \
	    --rm \
	    -v `pwd`/$(ARTIFACTS):/$(ARTIFACTS) \
	    -v `pwd`/$<:/make.sh:ro \
	    $(DOCKER_IMAGE_TAG) \
	    bash /make.sh


# Main user-invokable targetns
.PHONY: dockerfile dockerimage makefile git
dockerfile: $(TARGET_DOCKER_FILE)
dockerimage: $(TARGET_IMAGE_FILE)
makefile: $(TARGET_MAKE_FILE)
git:  $(dockerfile) $(dockerimage) $(APP_TAR_ON_HOST)


.PHONY: all
all: git


.PHONY: clean
clean:
	-rm -rf $(WORKDIR)
	-rm -rf $(ARTIFACTS)

