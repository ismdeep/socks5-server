Name:      socks5-server
Version:   0.0.1
Release:   1

License:   MIT
URL:       http://www.example.com/
Summary:   Socks5 Server
# use build-time generated tar ball.
Source0:   %{name}.tar.gz
# (only create temporary directory name, for RHEL5 compat environment)
# see : http://fedoraproject.org/wiki/Packaging:Guidelines#BuildRoot_tag
BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

%define INSTALLDIR %{buildroot}
%define debug_package %{nil}

%description
%{summary}

%prep
%setup -q -n %{name}

%build
go build \
  -o ./build/rpm/socks5-server/usr/bin/socks5-server \
  -mod vendor \
  -trimpath \
  -ldflags "-w -s" \
  .

%install
rsync -a -r --no-i-r --info=progress2 --info=name0 --no-owner --no-group --no-perms \
  ./build/rpm/socks5-server/ \
  %{INSTALLDIR}/

%clean

%files
%defattr(-,root,root,-)
/usr/bin/socks5-server
/etc/systemd/system/socks5-server.service

%pre

%post
systemctl enable socks5-server --now || true

%preun
systemctl disable socks5-server --now || true

%postun

%changelog