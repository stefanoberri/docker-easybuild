# docker-easybuild

Collection of Dockerfile files that build docker images using
[EasyBuild](https://hpcugent.github.io/easybuild/). 

Built images depends on each other. In each directory, there are Dockerfiles
that depend on the image built one layer above. 

Each Directory also have Makefile to help with the recursive creation of
images and a README.md file with information about the produced image

# EasyBuild

The root directory contains a Dockerfile to build EasyBuild. The image produced
is also available from the linked [DockerHub
repository](https://hub.docker.com/r/sberri/easybuild/)

## Motivation

Despite it might seem that EasyBuild perfectly overlaps Docker functionality,
it is in fact complementary to Docker

- Software built using EasyBuild can be reproducibly built in other
  environments (i.e. HPC clusters, shared workstation) without root priviledges
- EasyBuild has a more controlled, reproducible, systematic and documented
  mechanism to install software than other tools such as `apt-get install`, `yum
  install` or `pip install`.


