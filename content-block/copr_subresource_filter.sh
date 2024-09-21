#! /bin/bash -x

# Get the spec to package
#wget https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block/chromium-subresource_filter.spec
wget https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/content-block/chromium-subresource_filter.spec # test url, the above will be used in prod

# Dummy file to pass build?
touch hardend-chromium_blocklist
