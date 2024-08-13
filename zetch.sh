#! /usr/bin/env bash 

# setting ?
# You want settings ?
# Look no further, adjust the variables below lmao
COLUMN=6
BLACK=0
RED=1
GREEN=2
YELLOW=3
BLUE=4
MAGENTA=5
CYAN=6
WHITE=7
DEFAULT=9

show_fonts() {
  for font in $(ls /usr/share/figlet/fonts | sed 's/\(.*\.flc\|\.flf\)//g')
  do
    figlet -f $font $font
  done
}

show_logo() {
  DISTRO_NAME=$(cat /etc/os-release | grep "PRETTY_NAME=" | cut -d "=" -f 2 | sed 's/\("\| .*\)//g')
  echo $(tput bold) $(tput setaf 4) 
  figlet -f smslant $DISTRO_NAME
  echo -n $(tput sgr0)
}

print_mod() {
  # format to be used 
  # print_mod(COLOR, ICON, NAME, VALUE)
  
  echo -n $(tput bold)
  echo -n "│ "

  # print the colored icon 
  echo -n $(tput setaf $1) 
  echo -n "${2} "
  echo -n $(tput setaf $WHITE)

  printf " %-${COLUMN}s" $3

  echo -n " │ "
  echo -n $(tput setaf $1) 
  shift 3
  echo -n "${@}"
  echo $(tput setaf $DEFAULT)
  echo -n $(tput sgr0)
}

dummy_print() {
  echo "dummy text"
}

show_top() {
  echo -n "╭"

  for (( i = 1; i <= ${COLUMN} + 5; i++))
  do 
    echo -n "─"
  done

  echo "╮"
}

show_bottom() {
  echo -n "╰"

  for (( i = 1; i <= ${COLUMN} + 5; i++))
  do 
    echo -n "─"
  done

  echo "╯"
}

show_user() {
  echo $USER
}

show_hname() {
  cat /etc/hostname
}

show_pretty_disro() {
  cat /etc/os-release | grep "PRETTY_NAME=" | cut -d "=" -f 2 | sed 's/"//g'
}

show_kernel() {
  uname -r
}

show_shell() {
  echo $SHELL
}

show_packages() {
  if $(command -v apt 1>/dev/null); then 
    echo $(dpkg –get-selections | wc -l) "(deb)"
  elif $(command -v pacman 1>/dev/null); then 
    echo $(pacman -Q | wc -l) "(pacman)"
  elif $(command -v dnf 1>/dev/null); then 
    echo $(dnf list installed | wc -l) "(rpm)"
  fi
}

show_uptime() {
  uptime -p
}

show_memory() {
  echo $(free -h | awk '/Mem:/{print $3}') "|" $(free -h | awk '/Mem:/{print $2}')
}

main() {
  show_logo

  show_top

  # define modules here
  print_mod $RED "" "user" $(show_user)
  print_mod $YELLOW "󰍹" "hname" $(show_hname)
  print_mod $GREEN "󰌽" "distro" $(show_pretty_disro)
  print_mod $CYAN "" "kernel" $(show_kernel)
  print_mod $BLUE "" "uptime" $(show_uptime)
  print_mod $MAGENTA "" "shell" $(show_shell)
  print_mod $RED "󰏔" "pkgs" $(show_packages)
  print_mod $YELLOW "󰍛" "memory" $(show_memory)

  show_bottom
}

main
