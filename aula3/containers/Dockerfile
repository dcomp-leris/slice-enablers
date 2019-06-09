FROM ubuntu:latest
RUN \
  apt update && \
  apt upgrade -y && \
  apt install -y tzdata && \
  echo "America/Sao_Paulo" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata  && \
  apt install -y python3-pip && \
  apt install -y net-tools && \
  pip3 install schedule && \
  apt install -y iperf3 && \
  apt install -y iperf &&\
  apt install -y stress && \
  apt install -y stress-ng && \
  apt install -y git