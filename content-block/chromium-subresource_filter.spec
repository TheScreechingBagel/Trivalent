Name:	 hardened-chromium-subresource_filter
Version: 1.1
%{lua: print("Release: "..os.time().."\n")}
Summary: Filters used by hardened-chromium to provide adblocking.
License: GPL-2.0
Requires: hardened-chromium

%description
Filters used by hardened-chromium to provide adblocking.

%build
LISTS="easylist.txt,easyprivacy.txt"
LIST_SOURCES="https://easylist.to/easylist/easylist.txt https://easylist.to/easylist/easyprivacy.txt"

# Get the filters that will be added
for source in $LIST_SOURCES; do
	wget $source
done

# Get chromium's source, no easier way
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$(pwd)/depot_tools:$PATH"
mkdir ./chromium && cd ./chromium
fetch --nohooks --no-history chromium
cd src
gclient runhooks
gn gen out/Release

# Build the filter generation tool
ninja -C out/Release/ subresource_filter_tools
cd ../../ # get back to the main directory from ./chromium/src/

# Generate the filterlist
./chromium/src/out/Release/ruleset_converter --input_format=filter-list --output_format=unindexed-ruleset --input_files=$LISTS --output_file=hardened-chromium_blocklist

# Cleanup
rm easylist.txt easyprivacy.txt
rm -rf ./chromium ./depot_tools

%install
install -m 0644 hardened-chromium_blocklist %{buildroot}%{_sysconfdir}/chromium/hardened-chromium_blocklist

%files
%{_sysconfdir}/chromium/hardened-chromium_blocklist
