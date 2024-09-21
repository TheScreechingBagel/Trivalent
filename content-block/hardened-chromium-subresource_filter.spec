Name:	  hardened-chromium-subresource_filter
License:  GPL-2.0
Requires: hardened-chromium
Version:  1.0
# Automatically generated version number, so that it doesn't need to be incremented manually
%{lua: print("Release: "..os.time().."\n")}

%description
Filters used by hardened-chromium to provide adblocking.

%install
install -m 0644 hardened-chromium_blocklist %{buildroot}%{_sysconfdir}/chromium/hardened-chromium_blocklist

%files
%{_sysconfdir}/chromium/hardened-chromium_blocklist
