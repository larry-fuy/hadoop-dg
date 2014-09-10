FROM ubuntu:precise
MAINTAINER Yong Fu

#Install curl
RUN apt-get update
RUN apt-get install -y curl

#Install sudo
RUN apt-get install -y sudo
ADD conf/sudoers /etc/sudoers
RUN chmod u+r,g+r,o= /etc/sudoers

#install git
RUN apt-get install -y git

#install maven
RUN apt-get install -y maven

# Install package with add-apt-repository
RUN apt-get install -y python-software-properties

# Enable Ubuntu repositories with Oracle Java
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

# Install latest Oracle Java from PPA
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
  apt-get install -y oracle-java7-installer oracle-java7-set-default

# Install hadoop
RUN curl http://www.dsgnwrld.com/am/hadoop/common/hadoop-2.5.0/hadoop-2.5.0.tar.gz > hadoop-2.5.0.tar.gz
RUN tar -xvf hadoop-2.5.0.tar.gz
ENV HADOOP_INSTALL /hadoop-2.5.0

# Download hadoop book source code
RUN git clone https://github.com/tomwhite/hadoop-book.git
RUN cd hadoop-book && mvn package -DSkipTests

# Environment
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV HADOOP_CLASSPATH hadoop-examples.jar

ENTRYPOINT export PATH=$PATH:$HADOOP_INSTALL/bin&&/bin/bash