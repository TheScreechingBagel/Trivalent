#! /bin/bash -x

# Preset variables
readonly SPEC_FILE="hardened-chromium-subresource_filter.spec"
readonly SCRIPT_FILE="generate_subresource_filter.sh"
#readonly GIT_URL="https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block"
readonly GIT_URL="https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/content-block" # test url, the above will be used in prod

# Checksums use SHA384
readonly SPEC_CHECKSUM="b2d6c4021666f7aef6992716a2e50edd76e0ec3d202c9b97c4cf45214162b105ef7a9f9fa20e34b8d1829d95de2fbe45"
readonly SCRIPT_CHECKSUM="$SCRIPT_FILE" # dummy value, generation script should be modifiable for now, later on it doesn't need to be though

# Get a file from whatever source and, given a checksum, validate it
download_and_verify() {
	FAILED_COUNT=0
	while [ "$FAILED_COUNT" -lt $((4)) ]; do
		wget $2
		sha384sum $1 | grep -w $3
		if [ "$?" == 1 ]; then
			echo "ERROR! Checksum for $1 does not match!"
			rm $1
			if [ "$FAILED_COUNT" == $((3)) ]; then
				echo "Failed to validate too many times, exiting..."
				exit 1
			else
				echo "Retrying..."
			fi
			FAILED_COUNT=$((FAILED_COUNT+1))
		else
			echo "$1 checksum validated."
			break
		fi
	done
}

download_and_verify $SPEC_FILE $GIT_URL/$SPEC_FILE $SPEC_CHECKSUM
download_and_verify $SCRIPT_FILE $GIT_URL/$SCRIPT_FILE $SCRIPT_CHECKSUM

# Run generation script
chmod u+x $SCRIPT_FILE && ./$SCRIPT_FILE
