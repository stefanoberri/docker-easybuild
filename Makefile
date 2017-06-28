DOCKER_BUILD_OPTIONS = \
	--shm-size=64MB \
	-f Dockerfile

all: docker.stdout
	
docker.stdout: Dockerfile
	sudo docker build $(DOCKER_BUILD_OPTIONS) . 1> docker.stdout 2> docker.stderr

clean:
	rm -f docker.stdout docker.stderr
