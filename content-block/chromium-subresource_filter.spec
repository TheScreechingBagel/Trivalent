Name:	 hardened-chromium-subresource_filter
Version: 1
Release: %(perl -e 'print time()')
Summary: Filters used by hardened-chromium to provide adblocking
License: GPL-2.0

%install
install -m 0644 hardened-chromium_blocklist %{buildroot}%{_sysconfdir}/chromium/filters/hardened-chromium_blocklist

%files
%{_sysconfdir}/chromium/filters/hardened-chromium_blocklist
