# SERVER MUST END WITH /
SERVER     =
NAMESPACE  = sberri
EB_VERSION = 3.4.0
REPO       = easybuild
GITTAG     = $(shell HOME=/dev/null git describe --always)
TAG  	     = $(EB_VERSION)-$(GITTAG)

# Folder where "sentinel files" are saved to track steps that do not produce
# files
BUILD      = $(CURDIR)/build


FULLTAG    = $(SERVER)$(NAMESPACE)/$(REPO):$(TAG)
SANBUILD   = $(abspath $(BUILD))

STDOUT_FILE = $(SANBUILD)/docker_stdout_$(NAMESPACE)_$(REPO)_$(TAG)

DOCKER_BUILD_OPTIONS = \
	--shm-size=1024MB \
	-f Dockerfile \
	-t $(FULLTAG)


all: $(SANBUILD)/.sentinel $(STDOUT_FILE)

$(STDOUT_FILE): Dockerfile
	sudo docker build $(DOCKER_BUILD_OPTIONS) . > $(STDOUT_FILE)

clean:
	rm -f $(STDOUT_FILE)

.PRECIOUS: %/.sentinel
%/.sentinel:
	mkdir -p $* || ( sleep 5 &&  mkdir -p $* ); touch $@

