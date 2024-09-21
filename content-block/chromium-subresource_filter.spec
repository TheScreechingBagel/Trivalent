Name:	 hardened-chromium-subresource_filter
Version: 1
#%{lua: print("Release: "..os.date("!%Y.%m.%d-%H.%M.%S").."\n"}
%{lua: print("Release: "..os.time().."\n")}
#Release: %autorelease
Summary: Filters used by hardened-chromium to provide adblocking.
License: GPL-2.0
Requires: hardened-chromium

%description
Filters used by hardened-chromium to provide adblocking.

%install
install -m 0644 hardened-chromium_blocklist %{buildroot}%{_sysconfdir}/chromium/hardened-chromium_blocklist

%files
%{_sysconfdir}/chromium/hardened-chromium_blocklist
