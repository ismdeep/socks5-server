# socks5-server

## Release

Push a tag like `0.0.1` to trigger GitHub Actions release packaging and upload these assets to GitHub Releases.
The release job now builds everything directly on an `amd64` runner without Docker:

- `build/socks5-server_linux_amd64`
- `build/socks5-server_linux_arm64`
- `socks5-server_<version>_amd64.deb`
- `socks5-server_<version>_arm64.deb`
- `socks5-server-<version>-1.x86_64.rpm`
- `socks5-server-<version>-1.aarch64.rpm`

All final build outputs are written under `build/`.

Version resolution is maintained in `version.sh`:

- `main` and `master` map to `0.0.0`
- `develop/*` maps to the branch suffix
- `release/*` maps to the branch suffix
- tags map to the tag name itself

You can also build the same assets locally:

```bash
make build
```

Local packaging requires these host tools:

- `go`
- `dpkg-deb`
- `rpmbuild`
