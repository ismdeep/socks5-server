.PHONY: help
help:
	@cat Makefile | grep '# `' | grep -v '@cat Makefile'

# `make prepare`
.PHONY: prepare
prepare:
	cd ./local/socks5-server-builder/ && \
		docker-compose --progress plain down && \
		docker-compose --progress plain pull && \
		docker-compose --progress plain up -d

# `make prepare-clean`
.PHONY: prepare-clean
prepare-clean:
	docker-compose \
		--progress plain \
		--project-directory "$$(pwd)/local/socks5-server-builder" \
		down

# `make deb-amd64`
.PHONY: deb-amd64
deb-amd64:
	docker exec socks5-server-builder-deb-amd64 rm -rf /build/
	docker exec socks5-server-builder-deb-amd64 mkdir -p /build/socks5-server/
	docker cp . socks5-server-builder-deb-amd64:/build/socks5-server/
	docker exec --workdir /build/socks5-server socks5-server-builder-deb-amd64 dpkg-buildpackage -us -uc
	mkdir -p ./output/
	docker cp socks5-server-builder-deb-amd64:/build/socks5-server_0.0.1_amd64.deb ./output/

# `make deb-arm64`
.PHONY: deb-arm64
deb-arm64:
	docker exec socks5-server-builder-deb-arm64 rm -rf /build/
	docker exec socks5-server-builder-deb-arm64 mkdir -p /build/socks5-server/
	docker cp . socks5-server-builder-deb-arm64:/build/socks5-server/
	docker exec --workdir /build/socks5-server socks5-server-builder-deb-arm64 dpkg-buildpackage -us -uc
	mkdir -p ./output/
	docker cp socks5-server-builder-deb-arm64:/build/socks5-server_0.0.1_arm64.deb ./output/

# `make rpm-amd64`
.PHONY: rpm-amd64
rpm-amd64:
	docker exec socks5-server-builder-rpm-amd64 rm -rf /build/
	docker exec socks5-server-builder-rpm-amd64 mkdir -p /build/socks5-server/
	docker cp . socks5-server-builder-rpm-amd64:/build/socks5-server/
	docker exec --workdir /build/socks5-server socks5-server-builder-rpm-amd64 bash buildrpm.sh
	mkdir -p ./output/
	docker cp socks5-server-builder-rpm-amd64:/build/socks5-server/rpmbuild/RPMS/x86_64/socks5-server-0.0.1-1.x86_64.rpm ./output/

# `make rpm-arm64`
.PHONY: rpm-arm64
rpm-arm64:
	docker exec socks5-server-builder-rpm-arm64 rm -rf /build/
	docker exec socks5-server-builder-rpm-arm64 mkdir -p /build/socks5-server/
	docker cp . socks5-server-builder-rpm-arm64:/build/socks5-server/
	docker exec --workdir /build/socks5-server socks5-server-builder-rpm-arm64 bash buildrpm.sh
	mkdir -p ./output/
	docker cp socks5-server-builder-rpm-arm64:/build/socks5-server/rpmbuild/RPMS/aarch64/socks5-server-0.0.1-1.aarch64.rpm ./output/

# `make package`
.PHONY: package
package: deb-amd64 deb-arm64 rpm-amd64 rpm-arm64

# `make package-clean`
.PHONY: package-clean
package-clean:
	rm -rf ./build/deb/socks5-server/usr/bin/
	rm -rf ./debian/.debhelper/
	rm -rf ./debian/socks5-server/
	rm -rf ./debian/files
	rm -rf ./debian/socks5-server.debhelper.log
	rm -rf ./debian/socks5-server.substvars
	rm -rf ./output/

# `make clean`
.PHONY: clean
clean: prepare-clean package-clean
