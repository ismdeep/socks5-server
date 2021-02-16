FROM golang:1.19 AS builder
WORKDIR /src
COPY . .
RUN go build -o bin/main github.com/ismdeep/socks5-server

FROM debian:11
ENV SOCKS5_SERVER_BIND=0.0.0.0:1080
COPY --from=builder /src/bin/main /usr/bin/socks5-server
ENTRYPOINT ["socks5-server"]
