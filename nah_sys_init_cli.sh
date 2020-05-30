#!/bin/bash

# Spinning wait animation
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}
# Calculates system settings from user input
x=0
while [ $x -lt 1 ]
    do
        # Ask user for workstation number
        read -p "Enter workstation number: " wn
        hn="workstation-"$wn
        [[ $wn =~ ^[0-9]+$ ]] # Checks if number is less than 10
        if ((wn <= 9)); then
            ip="192.168.1."$(( wn - 1 ))  # Sets static IP, range starts at 10
        else
            ip="192.168.1."$(( wn + 10 - 1 )) # Adds 10 if workstation number exeeds 10
        fi
        clear
        x=$(( $x + 1 ))   # Ends while loop
    done

echo "Generated workstation settings: "
echo "  IP Addrress -> "$ip
echo "  Hostname    -> "$hn
echo
echo
echo
read -p "Use these settings to initialize this workstation (y/n)? " yn
if [ "$yn" != "${yn#[Yy]}" ]; then
    echo $hn > /etc/hostname
    sleep 2 &
    PID=$!
    i=1
    sp="/-\|"
    echo -n ' '
    while [ -d /proc/$PID ]
    do
        printf "\b${sp:i++%${#sp}:1}"
    done
#test
#    printf 'Setting hostname '
#    spinner &
#    sleep 5
#    kill "$!" # Kill the spinner
#    printf 'done\n'
#    printf 'Setting static address '
#    spinner &
#    sleep 5
#    kill "$!" # Kill the spinner
#    printf 'done\n'
else
    echo no
fi
