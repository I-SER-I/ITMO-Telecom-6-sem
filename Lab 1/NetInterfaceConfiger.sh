#!/bin/bash

model() {
    path="/sys/class/net/"
    lshw -class network | grep -i -E 'product:' | sed 's/^ *product: //g'
}

links() {
    printf "%-10s | %-10s\n" "INTERFACE" "LINK DETECTED"
    printf "%-10s | %-10s\n" "----------" "----------"
    for interface in $(ls $path)
    do
        printf "%-10s | %-10s\n" "$interface" "$(ethtool $interface | grep -i -E 'Link detected:' | sed 's/^\t*Link detected: //g')"
    done
}

stats() {
    printf "%-10s | %-10s | %-10s\n" "INTERFACE" "SPEED" "DUPLEX"
    printf "%-10s | %-10s | %-10s\n" "----------" "----------" "----------"
    for interface in $(ls $path)
    do
        printf "%-10s | %-10s | %-10s\n" "$interface" "$(ethtool $interface | grep -i -E 'Speed:' | sed 's/^\t*Speed: //g')" "$(ethtool $interface | grep -i -E 'Duplex:' | sed 's/^\t*Duplex: //g')"
    done
}

PS3='Please enter your choice: '
options=("Show network card model" "Check interfaces links" "Show speed and interface mode" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Show network card model")
            model
        ;;
        "Check interfaces links")
            links
        ;;
        "Show speed and interface mode")
            stats
        ;;
        "Quit")
            break
        ;;
        *) echo "Invalid option $REPLY";;
    esac
done