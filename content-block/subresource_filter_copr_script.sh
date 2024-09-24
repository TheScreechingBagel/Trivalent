#! /bin/bash -x

# Preset variables
readonly SPEC_FILE="hardened-chromium-subresource_filter.spec"
readonly CONVERTER_FILE="ruleset_converter"
#readonly GIT_URL="https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block"
readonly GIT_URL="https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/content-block" # test url, the above will be used in prod

# Checksums use SHA384
readonly SPEC_CHECKSUM="ea2102968648d90be129676ee7b594f5074ff39c2ca2eb00547f728f16a7afbc11257994d17f0131067a2ee75a8d0aed"
readonly CONVERTER_CHECKSUM="22ae277be977f8539e822526c7d8c278b65d7759abd72c530165839640a24f873d3745fd5b9e83baf37261963a594e12"

LISTS="easylist.txt,easyprivacy.txt"
LIST_SOURCES="https://easylist.to/easylist/easylist.txt https://easylist.to/easylist/easyprivacy.txt"

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
download_and_verify $CONVERTER_FILE $GIT_URL/$CONVERTER_FILE $CONVERTER_CHECKSUM

# Get the filters that will be added
for source in $LIST_SOURCES; do
	wget $source
done

# Run the converter file to generate the filterlist
chmod u+x $CONVERTER_FILE && ./$CONVERTER_FILE --input_format=filter-list --output_format=unindexed-ruleset --input_files=$LISTS --output_file=hardened-chromium_blocklist

# Cleanup (only needed for a local, non-copr, run)
rm easylist.txt easyprivacy.txt
