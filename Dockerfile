FROM golang:1.23.8-bullseye AS builder
WORKDIR /src
COPY ./build/ ./
RUN \
    case $(uname -m) in \
      amd64|x86_64) cp socks5-server_linux_amd64 socks5-server ;; \
      arm64|aarch64) cp socks5-server_linux_arm64 socks5-server ;; \
      *) echo "[ERROR] unsupported platform: $(uname -m)" && false ;; \
    esac

FROM debian:11
ENV SOCKS5_SERVER_BIND=0.0.0.0:1080
COPY --from=builder /src/socks5-server /usr/bin/socks5-server
ENTRYPOINT ["socks5-server"]
