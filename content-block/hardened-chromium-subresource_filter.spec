Name:      hardened-chromium-subresource_filter
BuildArch: noarch
Requires:  hardened-chromium
Source0:   hardened-chromium_blocklist
License:   GPL-2.0
Summary:   Subresource filter for hardened-chromium
Version:   1.0
# Automatically generated version number, so that it doesn't need to be incremented manually
%{lua: print("Release: "..os.time().."\n")}


%description
Filters used by hardened-chromium to provide adblocking.

%install
mkdir -p %{buildroot}%{_sysconfdir}/chromium
install -m 0644 %{SOURCE0} %{buildroot}%{_sysconfdir}/chromium/hardened-chromium_blocklist

%files
%{_sysconfdir}/chromium/hardened-chromium_blocklist
