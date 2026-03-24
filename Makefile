.PHONY: help
help:
	@cat Makefile | grep '# `' | grep -v '@cat Makefile'

VERSION ?= $(shell bash version.sh)

.PHONY: build-binary
build-binary:
	mkdir -p build
	CGO_ENABLED=0 GOOS=linux  GOARCH=amd64 go build -o build/socks5-server_linux_amd64  -trimpath -ldflags '-s -w' .
	CGO_ENABLED=0 GOOS=linux  GOARCH=arm64 go build -o build/socks5-server_linux_arm64  -trimpath -ldflags '-s -w' .
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o build/socks5-server_darwin_amd64 -trimpath -ldflags '-s -w' .
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -o build/socks5-server_darwin_arm64 -trimpath -ldflags '-s -w' .
	cd build && sha256sum socks5-server_linux_amd64 > socks5-server_linux_amd64.sha256sum
	cd build && sha256sum socks5-server_linux_arm64 > socks5-server_linux_arm64.sha256sum
	cd build && sha256sum socks5-server_darwin_amd64 > socks5-server_darwin_amd64.sha256sum
	cd build && sha256sum socks5-server_darwin_arm64 > socks5-server_darwin_arm64.sha256sum

.PHONY: build-deb
build-deb:
	VERSION=$(VERSION) bash ./builddeb.sh

.PHONY: build-rpm
build-rpm:
	VERSION=$(VERSION) bash ./buildrpm.sh

# `make build`
.PHONY: build
build: build-binary build-deb build-rpm

# `make clean`
.PHONY: clean
clean:
	rm -rf build/
