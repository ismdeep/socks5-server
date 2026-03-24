Name:      socks5-server
Version:   %{version}
Release:   1

License:   MIT
URL:       https://github.com/ismdeep/socks5-server
Summary:   Socks5 Server
Source0:   %{name}-%{version}-%{pkg_arch}.tar.gz
%define debug_package %{nil}
%global __strip /bin/true
%global __objdump /bin/true

%description
%{summary}

%prep
%setup -q -n %{name}-%{version}-%{pkg_arch}

%build

%install
mkdir -p %{buildroot}
cp -a usr %{buildroot}/
cp -a etc %{buildroot}/

%files
%defattr(-,root,root,-)
/usr/bin/socks5-server
/etc/systemd/system/socks5-server.service
/usr/share/doc/socks5-server/LICENSE

%pre

%post
systemctl enable socks5-server --now || true

%preun
systemctl disable socks5-server --now || true

%postun

%changelog
