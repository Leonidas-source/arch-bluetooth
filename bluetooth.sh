#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"
service_check() {
  systemctl status bluetooth.service | grep "enabled" && third="(service enabled)"
  systemctl status bluetooth.service | grep "enabled" || third="(service disabled)"
}
pkg_check() {
  pacman -Qi bluez && first="(already installed)"
  pacman -Qi bluez || first="(not installed)"
  pacman -Qi pulseaudio-alsa pulseaudio-bluetooth && second="(already installed)"
  pacman -Qi pulseaudio-alsa pulseaudio-bluetooth || second="(not installed)"
}
error() {
  clear
  echo "You must be root to execute this script"
  exit
}
user_check() {
  clear
  check=$(whoami)
  [ "$check" == root ] || error
}
menu() {
  pkg_check
  service_check
  clear
  echo -e "
  1) install bluez ${red}${bold}$first${reset}
  2) install pulseaudio-bluetooth ${red}${bold}$second${reset}
  3) enable bluetooth ${red}${bold}$third${reset}
  4) exit"
  read -r answr
  [ "$answr" == "1" ] && bluez
  [ "$answr" == "2" ] && pulseaudio
  [ "$answr" == "3" ] && bluetooth
  [ "$answr" == "4" ] && exit
}
bluez() {
  clear
  pacman -S bluez bluez-utils
  menu
}
pulseaudio() {
  clear
  pacman -S pulseaudio-alsa pulseaudio-bluetooth
  menu
}
bluetooth() {
  clear
  systemctl enable bluetooth.service
  menu
}
user_check
menu
