FROM sberri/easybuild:latest

MAINTAINER Stefano Berri <sberri@illumina.com>

# use easybuild to install goolf-1.7.20
RUN source /home/easybuild/setup.sh && eb goolf-1.7.20.eb --installpath=/opt/easybuild --buildpath=/tmp/easybuild -r && rm -rf /tmp/easybuild

