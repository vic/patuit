FROM ubuntu
MAINTAINER Victor Borja <vborja@apache.org>

# Use bash as default shell
RUN ln -sf /bin/bash /bin/sh

##
# Create and set user 'n' as default
##

RUN useradd -ms /bin/bash -d /n -G sudo n 
RUN echo 'n ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV USER n
USER ${USER}
ENV HOME /n
WORKDIR ${HOME}
CMD ["bash"]
RUN mkdir -p ${HOME}/opt


##
# Update ubuntu system and install base dependencies
##

RUN sudo apt-get update && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y \
         curl git unzip build-essential

##
# Locale en_US.UTF-8
##
RUN sudo apt-get install -y language-pack-en-base
RUN sudo locale-gen en_US.UTF-8
RUN sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
RUN sudo dpkg-reconfigure locales
RUN echo export LANG=en_US.UTF-8 | sudo tee -a ${HOME}/.bashrc
RUN echo export LC_ALL=en_US.UTF-8 | tee -a ${HOME}/.bashrc


##
# Install Oracle Java 7
##

RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository -y ppa:webupd8team/java
RUN sudo apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true |\
    sudo /usr/bin/debconf-set-selections
RUN sudo apt-get install -y oracle-java7-installer


##
# Install couchdb
##

RUN sudo add-apt-repository -y ppa:couchdb/stable
RUN sudo apt-get update
RUN sudo apt-get install -y couchdb


##
# Install neo4j
##

ENV NEO4J_VERSION 2.2.1

RUN curl http://neo4j.com/artifact.php?name=neo4j-community-${NEO4J_VERSION}-unix.tar.gz > /tmp/neo4j.tgz
RUN tar -C ${HOME}/opt -xvzf /tmp/neo4j.tgz
RUN rm /tmp/neo4j.tgz
ENV NEO4J_HOME ${HOME}/opt/neo4j-community-${NEO4J_VERSION}
ENV PATH ${NEO4J_HOME}/bin:${PATH}


##
# Install Ruby with rvm
##

ENV RUBY_VERSION 2.2.1

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -L https://get.rvm.io | bash -s stable
RUN source ~/.bash_profile &&\
    rvm install ruby-${RUBY_VERSION}
RUN source ~/.bash_profile &&\
    rvm alias create default ruby-${RUBY_VERSION}

##
# Fix path
#
# Dart tools:
#ENV PATH ${HOME}/.rvm/rubies/default/bin:${PATH}
#ENV PATH ${HOME}/.nvm/versions/node/${NODE_VERSION}/bin:${PATH}


