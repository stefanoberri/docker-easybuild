# SERVER MUST END WITH /
SERVER     =
NAMESPACE  = sberri
REPO       = easybuild
TAG        = goolf-1.7.20
# define what image must be present
DEPTAG     = 3.2.0

# Folder where "sentinel files" are saved to track steps that do not produce
# files
BUILD      = $(CURDIR)/build


FULLTAG    = $(SERVER)$(NAMESPACE)/$(REPO):$(TAG)
SANBUILD   = $(abspath $(BUILD))
DEPFULLTAG = $(SERVER)$(NAMESPACE)/$(REPO):$(DEPTAG)
DEPSTDOUTFILE = $(SANBUILD)/docker_stdout_$(NAMESPACE)_$(REPO)_$(DEPTAG)

STDOUT_FILE = $(SANBUILD)/docker_stdout_$(NAMESPACE)_$(REPO)_$(TAG)

DOCKER_BUILD_OPTIONS = \
	--shm-size=1024MB \
	-f Dockerfile \
	-t $(FULLTAG)


all: $(SANBUILD)/.sentinel $(STDOUT_FILE)

# go up one level and build. it takes very little if already exists
$(DEPSTDOUTFILE):
	cd .. && make BUILD=$(SANBUILD)

$(STDOUT_FILE): Dockerfile $(DEPSTDOUTFILE)
	sudo docker build $(DOCKER_BUILD_OPTIONS) . > $(STDOUT_FILE)

clean:
	rm -f $(STDOUT_FILE)

.PRECIOUS: %/.sentinel
%/.sentinel:
	mkdir -p $* || ( sleep 5 &&  mkdir -p $* ); touch $@

