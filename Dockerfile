FROM registry.stage.redhat.io/ubi8/ubi AS ubi-micro-build

RUN mkdir -p /mnt/rootfs/keys
RUN chmod 0777 /mnt/rootfs/keys
RUN yum install --installroot /mnt/rootfs --releasever 8 --setopt install_weak_deps=false --nodocs -y bash coreutils-single glibc-minimal-langpack openssl && \
    yum --installroot /mnt/rootfs clean all
RUN rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.*


# This image provides an openssl command line utility you can use for certificate management
FROM scratch

# Image metadata
ENV NAME="openssl"

ENV SUMMARY="OpenSSL Portable Certificate and Signing Container" \
    DESCRIPTION="Container with the openssl binary, giving ability \
to work with cryptographic keys and certificates needed for web servers."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      version="8.6" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="$NAME" \
      name="ubi8/${NAME}" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>" \
      com.redhat.component="${NAME}-container" \
      com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

COPY --from=ubi-micro-build /mnt/rootfs/ /

# Create and set mount volume
WORKDIR /keys
VOLUME  /keys

#USER 1001

#ENTRYPOINT ["/usr/bin/openssl"]
ENTRYPOINT ["sleep","10000000000"]
