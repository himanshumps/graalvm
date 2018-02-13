# aikido-graalvm
FROM registry.access.redhat.com/rhel7/rhel

MAINTAINER Himanshu Gupta <himanshu_gupta01@infosys.com>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="GraalVM" \
      io.k8s.display-name="GraalVM" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,graalvm" \
	  io.openshift.s2i.scripts-url=image:///usr/local/s2i

ENV APP_PATH=/opt/app-root \
    PATH="$APP_PATH/graalvm-0.31/bin:$APP_PATH/apache-maven-3.5.2/bin:${PATH}" \
    JAVA_HOME=$APP_PATH/graalvm-0.31
RUN yum install -y tar wget && yum clean all -y && rm -rf /var/cache/yum && mkdir -p $APP_PATH && cd /opt/app-root
COPY ./s2i/bin/ /usr/local/s2i

RUN wget https://github.com/himanshumps/graalvm/raw/master/graalvm-0.31-linux-amd64-jdk8.tar.gz http://www-eu.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gzm && tar xvzf graalvm-0.31-linux-amd64-jdk8.tar.gz && tar xvzf apache-maven-3.5.2-bin.tar.gz && rm -rf graalvm-0.31-linux-amd64-jdk8.tar.gz apache-maven-3.5.2-bin.tar.gz

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

RUN mvn -version

RUN java -version

RUN echo $JAVA_HOME
# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
