FROM ubuntu:latest
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install tzdata && \
  echo "America/Sao_Paulo" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata  && \
  apt-get -y install python3-pip && \
  pip3 install schedule && \
  apt-get -y install iperf3 && \
  apt-get -y install iperf &&\
  apt-get -y install stress && \
  apt-get -y install stress-ng && \
  apt-get -y install git