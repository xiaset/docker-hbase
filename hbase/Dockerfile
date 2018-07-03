FROM ubuntu:16.04
MAINTAINER Aset Madraimov <xiaset@gmail.com>
ARG HBASE_VERSION=1.2.6.1
ARG HBASE_MAJOR_VERSION=1.2
ARG PHOENIX_VERSION=4.8.1
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > \ 
    /etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk*
RUN apt-get update && \
    apt-get install -y curl python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN cd /opt && \
    wget http://www-eu.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz && \
    tar -xf hbase-$HBASE_VERSION-bin.tar.gz && rm -rf hbase-$HBASE_VERSION-bin.tar.gz && \
    ln -s hbase-$HBASE_VERSION hbase && \
    rm -rf hbase/docs
RUN cd /opt && \
    wget http://archive.apache.org/dist/phoenix/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR_VERSION/bin/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR_VERSION-bin.tar.gz && \
    tar -xf apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR_VERSION-bin.tar.gz && \
    rm -rf apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR_VERSION-bin.tar.gz && \
    ln -s apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR_VERSION-bin phoenix && \
    cp apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR_VERSION-bin/phoenix-*-server.jar hbase/lib/
RUN useradd hbase && \
    chown -R hbase /opt/*
COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
#CMD ["/opt/kafka/bin/kafka-mirror-maker.sh", "--consumer.config", "/opt/kafka/consumer.properties", "--producer.config", "/opt/kafka/producer.properties", "--whitelist", "echo ${KAFKA_WHITELIST}", "--num.streams", "echo ${KAFKA_NUMSTREAMS}"]
#CMD /opt/kafka/bin/kafka-mirror-maker.sh --consumer.config /opt/kafka/consumer.properties --producer.config /opt/kafka/producer.properties --whitelist ${KAFKA_WHITELIST} --num.streams ${KAFKA_NUMSTREAMS}
