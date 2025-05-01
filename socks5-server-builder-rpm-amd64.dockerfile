FROM openeuler/openeuler:24.03
ENV PATH=/go/bin:${PATH}
RUN \
    curl -fLO https://go.dev/dl/go1.23.8.linux-amd64.tar.gz && \
    tar -zxf go1.23.8.linux-amd64.tar.gz && \
    rm -fv go1.23.8.linux-amd64.tar.gz
RUN \
    yum install -y rpmdevtools make rsync git
CMD ["sleep", "infinity"]