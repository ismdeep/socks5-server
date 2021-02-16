#!/usr/bin/env bash

rm -rf bin/

GOOS=linux      GOARCH=amd64    go build -o bin/socks5-server-linux-amd64 github.com/ismdeep/socks5-server/server
GOOS=linux      GOARCH=386      go build -o bin/socks5-server-linux-386 github.com/ismdeep/socks5-server/server
GOOS=linux      GOARCH=arm64    go build -o bin/socks5-server-linux-arm64 github.com/ismdeep/socks5-server/server
GOOS=linux      GOARCH=arm      go build -o bin/socks5-server-linux-arm github.com/ismdeep/socks5-server/server
GOOS=darwin     GOARCH=amd64    go build -o bin/socks5-server-darwin-amd64 github.com/ismdeep/socks5-server/server
GOOS=windows    GOARCH=amd64    go build -o bin/socks5-server-windows-amd64.exe github.com/ismdeep/socks5-server/server
GOOS=windows    GOARCH=386      go build -o bin/socks5-server-windows-386.exe github.com/ismdeep/socks5-server/server
