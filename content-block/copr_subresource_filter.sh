#! /bin/bash -x

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

# Generate the filterlist
./chromium/src/out/Release/ruleset_converter --input_format=filter-list --output_format=unindexed-ruleset --input_files=$LISTS --output_file=hardened-chromium_blocklist

# Cleanup
rm easylist.txt,easyprivacy.txt
rm -rf ./chromium ./depot_tools

# Get the spec to package
##wget https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/chromium-subresource_filter.spec
wget https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/chromium-subresource_filter.spec # test url, the above will be used in prod
