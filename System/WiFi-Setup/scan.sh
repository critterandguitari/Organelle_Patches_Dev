#! /bin/bash

. /usr/lib/network/globals
. "$SUBR_DIR/wpa"
. "$SUBR_DIR/rfkill"

# Fills PROFILES and ESSIDS with the profile names and essids of the profiles
# for interface $1.
init_profiles()
{
    local i=0 essid profile
    while read -r profile; do
        essid=$(
            unset INTERFACE ESSID
            source "$PROFILE_DIR/$profile" > /dev/null
            if [[ "$Interface" = "$1" && -n "$ESSID" ]]; then
                printf "%s" "$ESSID"
                if [[ "$Description" =~ "Automatically generated" ]]; then
                    return 2
                else
                    return 1
                fi
            fi
            return 0
        )
        case $? in
            2)
                GENERATED+=("$profile")
                ;&
            1)
                PROFILES[i]=$profile
                ESSIDS[i]=$essid
                (( ++i ))
                ;;
        esac
    done < <(list_profiles)
}


# Builds ENTRIES as an argument list for dialog based on scan results in $1.
init_entries()
{
    local i=0 flags signal ssid
    while IFS=$'\t' read -r signal flags ssid; do
        ENTRIES[i++]="--"  # $ssid might look like an option to dialog.
        ENTRIES[i++]=$ssid
        if in_array "$ssid" "${ESSIDS[@]}"; then
            if in_array "$(ssid_to_profile "$ssid")" "${GENERATED[@]}"; then
                ENTRIES[i]="."  # Automatically generated
            else
                ENTRIES[i]="+"  # Handmade
            fi
        else
            ENTRIES[i]=" "  # Not present
        fi
        if [[ "$ssid" = "$CONNECTION" ]]; then
            ENTRIES[i]="*"  # Currently connected
        fi
        if [[ "$flags" =~ WPA2|WPA|WEP ]]; then
            ENTRIES[i]+=":${BASH_REMATCH[0],,}"
        else
            ENTRIES[i]+=":none"
        fi
        ENTRIES[i]+="   :$signal"
        (( ++i ))
    done < "$1"
}

# Finds a profile name for ssid $1.
ssid_to_profile()
{
    local i
    for i in $(seq 0 $((${#ESSIDS[@]}-1))); do
        if [[ "$1" = "${ESSIDS[i]}" ]]; then
            printf "%s" "${PROFILES[i]}"
            return 0
        fi
    done
    return 1
}

ensure_root "$(basename "$0")"

INTERFACE=$1
if [[ -z "$INTERFACE" ]]; then
    INTERFACE=(/sys/class/net/*/wireless/)
    if [[ "${#INTERFACE[@]}" -ne 1 || ! -d "$INTERFACE" ]]; then
        report_error "Invalid interface specification"
        usage
        exit 255
    fi
    INTERFACE=${INTERFACE:15:-10}
    report_debug "Using interface '$INTERFACE'"
fi
if [[ -x "$PROFILE_DIR/interfaces/$INTERFACE" ]]; then
    source "$PROFILE_DIR/interfaces/$INTERFACE"
fi

cd /  # We do not want to spawn anything that can block unmounting
if [[ ! -d "/sys/class/net/$INTERFACE" ]]; then
    exit_error "No such interface: $INTERFACE"
fi
if [[ "$RFKill" && "$(rf_status "$INTERFACE" "$RFKill")" ]]; then
    if ! rf_enable "$INTERFACE" "$RFKill"; then
        exit_error "Could not unblock transmission on interface '$INTERFACE'"
    fi
    RF_UNBLOCKED=1
fi


echo -n "Scanning for networks... "
CONNECTION=$(wpa_call "$INTERFACE" status 2> /dev/null | sed -n "s/^ssid=//p")
NETWORKS=$(wpa_supplicant_scan "$INTERFACE" 3,4,5)
RETURN=$?


if (( RETURN == 0 )); then
    trap 'rm -f "$NETWORKS"' EXIT
    echo "done"
    init_profiles "$INTERFACE"
    init_entries "$NETWORKS"
    MSG="Select the network you wish to use
Flags description:
 * - active connection present
 + - handmade profile present
 . - automatically generated profile present"
    for i in ${ENTRIES[@]}; do echo $i; done
    
fi









