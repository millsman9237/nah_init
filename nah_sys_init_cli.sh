#!/bin/bash

# Spinning wait animation
spinner() {
    local i sp n
    PID=$!
    i=1
    sp="/-\|"
    n=${#sp}
    echo -n ' '
    while [ -d /proc/$PID ]
    do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

# Set static IP
static() {
    nmcli con mod "Wired connection 1" \
    ipv4.addresses $ip"/24" \
    ipv4.gateway "192.168.1.1" \
    ipv4.dns "1.1.1.1,8.8.8.8" \
    ipv4.method "manual"
}

# Calculates system settings from user input
x=0
while [ $x -lt 1 ]
    do
        # Ask user for workstation number
        read -p "Enter workstation number: " wn
        hn="workstation-"$wn
        ip="192.168.1."$(( wn + 10 - 1 )) # Adds 10 if workstation number exeeds 10
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
    printf 'Setting hostname '
    spinner
    printf 'done\n'
    static
    sleep 2 &
    printf 'Applying network settings '
    spinner
    printf 'done\n'
else
    echo no
fi
