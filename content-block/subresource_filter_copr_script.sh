#! /bin/bash -x

# Checksums use SHA384
readonly SPEC_CHECKSUM="66ef842194dd061599c011ce839f6c843400c969bc60c1059e5406dc41023e4d13e0fdc7c432f367f6d477cd87bab614"
#readonly SCRIPT_CHECKSUM="" # generation script should be modifiable, later on it doesn't need to be though

# Get the spec to package
#wget https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block/chromium-subresource_filter.spec
wget https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/content-block/hardened-chromium-subresource_filter.spec # test url, the above will be used in prod

# Get the generation script
#wget https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block/generate_subresource_filter.sh
wget https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/content-block/generate_subresource_filter.sh # again, temporary for testing

sha384sum hardened-chromium-subresource_filter.spec | grep $SPEC_CHECKSUM
if [ "$?" == 1 ]; then
	echo "ERROR! Checksum for spec file does not match!"
	rm hardened-chromium-subresource_filter.spec
	exit 1
else
	echo "Spec file checksum validated."
fi
#sha384sum generate_subresource_filter.sh | grep $SCRIPT_CHECKSUM

# Run generation script
chmod u+x generate_subresource_filter.sh && ./generate_subresource_filter.sh
