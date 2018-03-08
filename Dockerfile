#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget autoconf pkg-config libmnl-dev libtool autogen && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]

RUN mkdir -p /root/honeytrap/m4
RUN mkdir /root/libnfnetlink-1.0.1
RUN mkdir /root/libnetfilter_queue-1.0.3

RUN git clone https://github.com/tillmannw/honeytrap.git temp
RUN mv -v temp/* honeytrap/ && rm -rf temp/ 
RUN wget https://netfilter.org/projects/libnfnetlink/files/libnfnetlink-1.0.1.tar.bz2
RUN tar -xvf libnfnetlink-1.0.1.tar.bz2 && rm libnfnetlink-1.0.1.tar.bz2
RUN cd libnfnetlink-1.0.1 && ./configure --prefix=/usr && make && make install
RUN wget https://netfilter.org/projects/libnetfilter_queue/files/libnetfilter_queue-1.0.3.tar.bz2
RUN tar -xvf libnetfilter_queue-1.0.3.tar.bz2 && rm libnetfilter_queue-1.0.3.tar.bz2
RUN cd libnetfilter_queue-1.0.3 &&  ./configure --prefix=/usr && make &&  make install
RUN cd /root/honeytrap &&  autoreconf -i configure.ac && ./configure --with-stream-mon=nfq &&  make &&  make install
