# docker-easybuild

Collection of Dockerfile files that build docker images using easybuild. 

Built images depends on each other. In each directory, there are Dockerfiles
that depend on the image built one layer above. 

Each Directory also have Makefile to help with the recursive creation of images



