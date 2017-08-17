FROM sberri/easybuild:3.2.0

MAINTAINER Stefano Berri <sberri@illumina.com>
# set default command. Note: it is still user easybuild

# install one/few steps at the time. Failing without saving intermediate images is
# too costly. 
# Install GCC and dependencies
RUN source /home/easybuild/setup.sh && \
  eb Anaconda3-4.2.0.eb \
    --installpath=/opt/easybuild \
    --buildpath=/tmp/easybuild -r && \
  rm -rf /home/easybuild/.local/easybuild && \
  rm -rf /tmp/easybuild

RUN echo "source /opt/lmod/lmod/init/bash" > /home/easybuild/setup.sh && \
  echo "module use /opt/easybuild/modules/all" >> /home/easybuild/setup.sh && \
  echo "module load Anaconda3/4.2.0" >> /home/easybuild/setup.sh 

CMD source /home/easybuild/setup.sh && bash
