#!/bin/bash
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
  clear
  echo "
  1) install bluez
  2) install pulseaudio-bluetooth
  3) enable bluetooth
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
