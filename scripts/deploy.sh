#!/bin/bash

configuration_list=("Release" "Adhoc")

release_date=$(TZ=JST-9 date '+%Y-%m-%d %H:%M:%S')
message="Build: ${CIRCLE_BUILD_NUM}, Uploaded: $release_date"

echo "${configuration_list[@]}"
for config in "${configuration_list[@]}"; do
    output_path="$PWD/build/${config}"

    echo -d "$DEVELOPER_NAME" -a "$APPNAME"
    ./build-ipa.sh \
        -d "$DEVELOPER_NAME" -a "$APPNAME" \
        -p "$PROFILE_NAME" \
        -t "$XCODE_TARGET" \
        -c "$config" \
        -o "$output_path"

    # ./upload-ipa-to-deploygate.sh \
    #     -u "$DEPLOYGATE_USER_NAME" -t "$DEPLOYGATE_API_TOKEN" -m "$message" \
    #     "${output_path}/${APPNAME}.ipa"
done

