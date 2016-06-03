FROM centos:7

MAINTAINER "Reiner Jung" <reiner@redcoolbeans.com>
ENV BACULA_VERSION "7.4.1"
LABEL com.baculasystems.bacula.version="${BACULA_VERSION}" \
      com.redcoolbeans.image.version="1.0.1"

ENV BACULA_COMPONENTS "bacula-libs bacula-common bacula-libs-sql bacula-storage"

# Install customer's repository information
ADD configs/bacula.repo /etc/yum.repos.d

RUN yum -q -y update && \
    yum -q -y install sudo
RUN for b in ${BACULA_COMPONENTS}; do yum -q -y install $b; done

RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

# Cleanup caches and repository information
RUN yum clean all; rm -f /etc/yum.repos.d/bacula.repo

ADD scripts/run.sh /
RUN chmod +x /run.sh

# Volume(s):
# /b: Default disk-based backup point. Can be a host-volume or a separate
#     container if needed.
VOLUME ["/b"]

ENTRYPOINT ["/run.sh"]

EXPOSE 9103
