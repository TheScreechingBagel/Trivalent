#! //bash -x

# Preset variables
readonly SPEC_FILE="hardened-chromium-subresource_filter.spec"
readonly CONVERTER_FILE="rule_converter"
#readonly GIT_URL="https://raw.githubusercontent.com/secureblue/hardened-chromium/refs/heads/master/content-block"
readonly GIT_URL="https://raw.githubusercontent.com/RKNF404/hardened-chromium/refs/heads/adblock-1/content-block" # test url, the above will be used in prod

# Checksums use SHA384
readonly SPEC_CHECKSUM="b2d6c4021666f7aef6992716a2e50edd76e0ec3d202c9b97c4cf45214162b105ef7a9f9fa20e34b8d1829d95de2fbe45"
readonly CONVERTER_CHECKSUM="35e224b534e50d473860dc13c397ff252fcbb51fc8cb7bac18330fe74049185791cc7610440e5bffe53f55c40abb8631"

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

# Cleanup
rm ruleset_converter easylist.txt easyprivacy.txt

# Run the converter file to generate the filterlist
chmod u+x $CONVERTER_FILE && ./$CONVERTER_FILE --input_format=filter-list --output_format=unindexed-ruleset --input_files=$LISTS --output_file=hardened-chromium_blocklist
