FROM ubuntu:20.04

ENV JMETER_VERSION 5.6.2
ENV JMETER_HOME /usr/local/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN $JMETER_HOME/bin
ENV IP 127.0.0.1
ENV RMI_PORT 1099

RUN apt-get -qq update && \
    apt-get -yqq install openjdk-11-jre unzip && \
    apt-get -q clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./dependencies /tmp/dependencies

RUN tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /usr/local && \
    unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME && \
    apt-get -yqq purge unzip && \
    apt-get -yqq autoremove && \
    rm -rf /tmp/dependencies

ENV PATH $PATH:$JMETER_BIN

WORKDIR $JMETER_HOME

EXPOSE $RMI_PORT

COPY ./docker-entrypoint.sh /root

ENTRYPOINT ["/root/docker-entrypoint.sh"]
