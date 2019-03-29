#!/bin/bash

TOUCHDEV_MATCHER="ELAN.*Touchpad"

# Each expression can match more than one setting */
TOUCHSETTING_MATCHER=( "Tapping Enabled (" \
                        "Natural Scrolling Enabled ("\
                        )

awkTouchDeviceId="$(cat <<"EOF"
	BEGIN {inPointer=0}
	/\[master\s*pointer[^]]*\]$/ {inPointer=1}
	inPointer && /[Tt]ouchpad/ {
		match($0, /id=[0-9]+/)
        if ( RSTART )
            start=RSTART
            match(substr($0, RSTART, RLENGTH), /[0-9]+/)
            print substr($0, RSTART+start-1, RLENGTH)
            exit
	}
	/\\[master\s*[^\\]]*\]$/ && $0 ~ /\\[master\s*pointer[^\\]]\\]$/ {
		inPointer=0
	}
EOF
)"

function grabDevId { xinput | awk "$awkTouchDeviceId" -; }

# echo id(s) of xinput dev $1 setting that matches regex $2
function grabSettingId {
    echo "$(xinput list-props "$1"|grep -i "$2"|grep -Eo '\([[:digit:]]*\)'|sed -Ee's/\(|\)//g')"
}

id="$(grabDevId $TOUCHDEV_MATCHER)"

for m in "${TOUCHSETTING_MATCHER[@]}"
do
    settingId=$(grabSettingId "$id" "$m")
    xinput set-prop "$id" "$settingId" 1
done
