FROM sberri/easybuild:3.2.0

MAINTAINER Stefano Berri <sberri@illumina.com>
# set default command. Note: it is still user easybuild

# install one/few steps at the time. Failing without saving intermediate images is
# too costly. 
# Install GCC and dependencies
RUN source /home/easybuild/setup.sh && \
  eb GCC-4.8.4.eb \
    --installpath=/opt/easybuild \
    --buildpath=/tmp/easybuild -r && \
  rm -rf /home/easybuild/.local/easybuild

RUN source /home/easybuild/setup.sh && \
  eb goolf-1.7.20.eb \
    --installpath=/opt/easybuild \
    --buildpath=/tmp/easybuild -r && \
  rm -rf /home/easybuild/.local/easybuild

RUN echo "source /opt/lmod/lmod/init/bash" > /home/easybuild/setup.sh && \
  echo "module use /opt/easybuild/modules/all" >> /home/easybuild/setup.sh && \
  echo "module load goolf/1.7.20" >> /home/easybuild/setup.sh 

CMD source /home/easybuild/setup.sh && bash
# # to use easybuild to install something do the following
# RUN source /home/easybuild/setup.sh && eb Python-2.7.11-goolf-1.7.20.eb --installpath=/opt/easybuild --buildpath=/tmp/easybuild -r && rm -rf /home/easybuild/.local
