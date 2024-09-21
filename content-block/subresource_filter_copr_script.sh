#! /bin/bash -x

# Get the spec to package
#wget https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block/chromium-subresource_filter.spec
wget https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/content-block/hardened-chromium-subresource_filter.spec # test url, the above will be used in prod

# Get the generation script
#wget https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block/generate_subresource_filter.sh
wget https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/generate_subresource_filter.sh # again, temporary for testing

# Run said script
chmod u+x generate_subresource_filter.sh && ./generate_subresource_filter.sh
