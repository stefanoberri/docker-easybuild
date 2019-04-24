FROM centos:centos7

MAINTAINER Stefano Berri <sberri@illumina.com>


### Prerequisites for both lmod and easybuild ###

# - Activate EPEL repos
# - lmod prerequisite: gcc make lua lua-posix lua-filesystem lua-devel tcl
# - easybuild prerequisites: git which bzip2 libibverbs-dev libibverbs-devel
#   however, when later installing other tools, further dependencies on the OS
#   are required. To minimise risk, install "Development tools"
RUN yum -y --enablerepo=extras install epel-release && \
  yum groupinstall -y "Development tools" && \
  yum install -y \
    which \
    libibverbs-dev \
    libibverbs-devel \
    lua \
    lua-posix \
    lua-filesystem \
    lua-devel \
    tcl \
    python-pip \
    python-wheel && \
  yum clean -y all

# SET up variables used by the build process
ENV \
  LMOD_VER=7.2.3 \
  EB_VER=3.4.0

####################
### Install Lmod ###
####################
# see https://github.com/rjeschmi/docker-lmod


# Download lmod
WORKDIR /tmp/build
RUN curl -LO http://github.com/TACC/Lmod/archive/${LMOD_VER}.tar.gz && \
    tar xvf ${LMOD_VER}.tar.gz > /dev/null && \
    cd Lmod-${LMOD_VER} && \
    ./configure --prefix=/opt && \
    make install && \
    ln -s /opt/lmod/lmod/init/profile /etc/profile.d/modules.sh && \
    ln -s /opt/lmod/lmod/init/cshrc /etc/profile.d/modules.csh && \
    rm -r /tmp/build/*

#########################
### install Easybuild ###
#########################
# see https://github.com/rjeschmi/docker-easybuild-centos7

# - add a non root user to install easybuild (easybuild does not install as root)
# - create a suitable directory and pass ownership to user easybuild
RUN useradd easybuild && \
    mkdir -p /opt/easybuild && chown easybuild:easybuild /opt/easybuild

# become that user for now on
USER easybuild

WORKDIR /home/easybuild

# Ironically, it is not possible to specify what version of easybuild to
# install via the bootstrap process, which has potentially serious consequences on reproducibility.
# However, using EasyBuild itself this is possible.
# Download and install the latest easybuild and then install the specific
# EasyBuild required
#
COPY EasyBuild-${EB_VER}.eb /home/easybuild/
# bash -l -c is required to have a bash login shell so that modules are
# correctly set
RUN curl -O \
  https://raw.githubusercontent.com/hpcugent/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py && \
  bash -l -c 'python bootstrap_eb.py /opt/easybuild/tmp' && \
  source /opt/lmod/lmod/init/bash && \
  module use /opt/easybuild/tmp/modules/all && \
  module load EasyBuild && \
  eb /home/easybuild/EasyBuild-${EB_VER}.eb --force --installpath=/opt/easybuild --buildpath=/tmp/easybuild -r && \
  rm -f /home/easybuild/bootstrap_eb.py && \
  rm -rf /opt/easybuild/tmp \
    /tmp/easybuild \
    /home/easybuild/.local \
    /home/easybuild/EasyBuild-${EB_VER}.eb

# then create a simple file to source and set the environment
RUN echo "source /opt/lmod/lmod/init/bash" > /home/easybuild/setup.sh && \
  echo "module use /opt/easybuild/modules/all" >> /home/easybuild/setup.sh && \
  echo "module load EasyBuild/${EB_VER}" >> /home/easybuild/setup.sh

# set default command. Note: it is still user easybuild
CMD source /home/easybuild/setup.sh && bash
# # to use easybuild to install something do the following
# RUN source /home/easybuild/setup.sh && eb goolf-1.7.20.eb --installpath=/opt/easybuild --buildpath=/tmp/easybuild -r && rm -rf /tmp/easybuild
