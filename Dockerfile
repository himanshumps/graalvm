# aikido-graalvm
FROM registry.access.redhat.com/rhel7/rhel
ARG GRAALVM_DOWNLOAD_PATH
MAINTAINER Himanshu Gupta <himanshu_gupta01@infosys.com>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="GraalVM" \
      io.k8s.display-name="GraalVM" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,graalvm" \
	  io.openshift.s2i.scripts-url=image:///usr/local/s2i


ENV PATH="/opt/app-root/graalvm-0.31/bin:/opt/app-root/apache-maven-3.5.2/bin:${PATH}"
ENV JAVA_HOME="/opt/app-root/graalvm-0.31"
RUN yum install -y tar wget && yum clean all -y && rm -rf /var/cache/yum && mkdir -p /opt/app-root

COPY ./s2i/bin/ /usr/local/s2i
WORKDIR /opt/app-root
RUN wget http://localhost:8085/getFile/graalvm-0.31-linux-amd64-jdk8.tar.gz http://localhost:8085/getFile/apache-maven-3.5.2-bin.tar.gz
RUN tar xvzf graalvm-0.31-linux-amd64-jdk8.tar.gz && tar xvzf apache-maven-3.5.2-bin.tar.gz && rm -rf graalvm-0.31-linux-amd64-jdk8.tar.gz apache-maven-3.5.2-bin.tar.gz

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root
RUN pwd
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080
RUN pwd
RUN echo $PATH
RUN echo $JAVA_HOME
RUN mvn -version && echo $PATH && java -version && echo $JAVA_HOME
# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
