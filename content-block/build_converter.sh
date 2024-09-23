#! /bin/bash -x

# Get chromium's source
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$(pwd)/depot_tools:$PATH"
mkdir ./chromium && cd ./chromium
fetch --nohooks --no-history chromium
cd src
gclient runhooks
gn gen out/Release

# Build the filter generation tool
ninja -C out/Release/ subresource_filter_tools
cd ../../

# Copy the result
cp ./chromium/src/out/Release/ruleset_converter .

# Cleanup
rm -rf ./chromium ./depot_tools
