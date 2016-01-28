FROM centos:7

MAINTAINER "Jasper Lievisse Adriaanse" <jasper@redcoolbeans.com>
ENV BACULA_VERSION "7.4.0"
LABEL com.baculasystems.bacula.version="${BACULA_VERSION}" \
      com.redcoolbeans.image.version="1.0.0"

ENV BACULA_COMPONENTS "bacula-client"

# Install customer's repository information
ADD configs/bacula.repo /etc/yum.repos.d

RUN yum -q -y update && \
    yum -q -y install postgresql sudo
RUN for b in ${BACULA_COMPONENTS}; do yum -y install $b; done

RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

# Cleanup caches and repository information
RUN yum clean all; rm -f /etc/yum.repos.d/bacula.repo

# Add and save a copy of the config file so we can re-populate it anytime
ADD configs/bacula-fd.conf /opt/bacula/etc/bacula-fd.conf
RUN cp /opt/bacula/etc/bacula-fd.conf{,.orig}

ADD scripts/run.sh /

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

EXPOSE 9101
