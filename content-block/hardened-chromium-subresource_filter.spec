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
mkdir -p "%{buildroot}%{_sysconfdir}/chromium"
install -m 0644 %{SOURCE0} "%{buildroot}%{_sysconfdir}/chromium/hardened-chromium_blocklist"

%uninstall
if [ -d "%{getenv:HOME}/.config/chromium/Subresource Filter" ]; then
	rm -rf "%{getenv:HOME}/.config/chromium/Subresource Filter"
fi

%posttrans
OLD_DIR="%{getenv:HOME}/.config/chromium/Subresource Filter"
if [ -d "$OLD_DIR" ]; then
	rm -rf "$OLD_DIR"
	NEW_DIR="$OLD_DIR/Unindexed Rules/%{release}.%{version}"
	mkdir -p "$NEW_DIR"
	cp "%{buildroot}%{_sysconfdir}/chromium/hardened-chromium_blocklist" "$NEW_DIR/Filtering Rules"
	cat << EOF > "$NEW_DIR/manifest.json"
{
  "manifest_version": 2,
  "name": "Subresource Filtering Rules",
  "ruleset_format": 1,
  "version": "%{release}.%{version}"
}
EOF
fi

%files
%{_sysconfdir}/chromium/hardened-chromium_blocklist
