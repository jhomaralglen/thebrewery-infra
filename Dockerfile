FROM registry.redhat.io/ubi8/s2i-base

ENV SUMMARY="Base image with essential libraries and tools used as a base for \
builder images like perl, python, ruby, etc." \
    DESCRIPTION="The s2i-base image, being built upon s2i-core, provides any \
images layered on top of it with all the tools needed to use source-to-image \
functionality. Additionally, s2i-base also contains various libraries needed for \
it to serve as a base for other builder images, like s2i-python or s2i-ruby." \
    NODEJS_VER=14

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="s2i base" \
      com.redhat.component="s2i-base-container" \
      name="ubi8/s2i-base" \
      version="1" \
      com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

# This is the list of basic dependencies that all language container image can
# consume.
RUN yum -y module enable nodejs:$NODEJS_VER && \
  INSTALL_PKGS="jq" && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum -y clean all --enablerepo='*'

# Install kubeseal CLI
RUN wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-amd64 -O kubeseal
RUN chmod +x kubeseal
RUN mv kubeseal /usr/local/bin/kubeseal

CMD ["/bin/sh"]
