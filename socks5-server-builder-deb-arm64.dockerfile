FROM debian:11
ENV PATH=/go/bin:${PATH}
RUN \
    apt-get update && \
    apt-get install -y curl dpkg-dev debhelper rsync build-essential
RUN \
    curl -fLO https://go.dev/dl/go1.23.8.linux-arm64.tar.gz && \
    tar -zxf go1.23.8.linux-arm64.tar.gz && \
    rm -fv go1.23.8.linux-arm64.tar.gz
CMD ["sleep", "infinity"]