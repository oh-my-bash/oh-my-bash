#!/usr/bin/env bash

: << 'COUT'
Todo features
     - Setting power, screenlock, etc.
COUT

initenv(){
    ## Define print color
    c0="\033[0m"
    bold="\033[1m"
    underline="\033[4m"
    red="\033[31m"
    green="\033[32m"
    yellow="\033[33m"
    blue="\033[34m"

    DEF=1
    showbanner
    trap "kill -9 $$" KILL
    [[ -z "$MISC" ]] && MISC="$HOME/Downloads/misc"
    mkdir -p $MISC && cd $MISC
    printf "${blue}%s ${c0}${bold}%s %s${c0}\n" "==>" "Working repository  -->" $MISC
    IP_PRE="192.168.3."
    GW=$IP_PRE"252"
    NS="8.8.8.8"
    getos
}

insconky(){
    showbar 5 &
    setapt
    sudo apt install -y conky conky-all build-essential git curl aptitude python-keyring ttf-ubuntu-font-family &>/dev/null
    cd ~/Downloads
    git clone https://github.com/helmuthdu/conky_colors.git &>/dev/null
    cd conky_colors && make &>/dev/null
    sudo make install &>/dev/null
    conky-colors --lang=en --theme=human --side=right --$OS_VER --cpu=2 --swap --updates --proc=3 --clock=modern --calendarm --hd=meerkat --network &>/dev/null
    kill -9 $!
    echo
    cat <<"EOF">conkyrc
######################
# - Conky settings - #
######################
update_interval 1
total_run_times 0
net_avg_samples 1
cpu_avg_samples 1
if_up_strictness link

imlib_cache_size 0
double_buffer yes
no_buffers yes

format_human_readable

#####################
# - Text settings - #
#####################
use_xft yes
xftfont Liberation Sans:size=8
override_utf8_locale yes
text_buffer_size 2048

#############################
# - Window specifications - #
#############################
own_window_class Conky
own_window yes
own_window_type normal
own_window_transparent yes
own_window_argb_visual yes
own_window_argb_value 200
own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager

alignment top_right
gap_x 25
gap_y 40
minimum_size 182 600
maximum_width 182

default_bar_size 60 8

#########################
# - Graphics settings - #
#########################
draw_shades no

default_color cccccc

color0 white
color1 CE5C00
color2 white
color3 CE5C00

TEXT
${font Liberation Sans:style=Bold:size=8}SYSTEM $stippled_hr${font}
##############
# - SYSTEM - #
##############
${color0}${voffset 8}${offset 4}${font ConkyColorsLogos:size=9}u${font}${color}${voffset -16}
${color0}${font ConkyColors:size=16}b${font}${color}
${goto 32}${voffset -23}Kernel: ${alignr}${color2}${kernel}${color}
${goto 32}Uptime: ${alignr}${color2}${uptime}${color}
# |--UPDATES
${goto 32}Updates: ${alignr}${font Liberation Sans:style=Bold:size=8}${color1}${execi 360 aptitude search "~U" | wc -l | tail}${color}${font} ${color2}Packages${color}
# |--CPU
${voffset 4}${color0}${font ConkyColors:size=16}c${font}${offset -20}${voffset 6}${cpubar cpu0 4,17}${color}${voffset -16}${goto 32}CPU1: ${font Liberation Sans:style=Bold:size=8}${color1}${cpu cpu1}%${color}${font} ${alignr}${color2}${cpugraph cpu1 8,60 E07A1F CE5C00}${color}
# ${goto 32}CPU2: ${font Liberation Sans:style=Bold:size=8}${color1}${cpu cpu2}%${color}${font} ${alignr}${color2}${cpugraph cpu2 8,60 E07A1F CE5C00}${color}
# |--MEM
${voffset 2}${color0}${font ConkyColors:size=15}g${font}${color}${goto 32}${voffset -7}RAM: ${font Liberation Sans:style=Bold:size=8}${color1}$memperc%${color}${font}
${offset 1}${color0}${membar 4,17}${color}${goto 32}F: ${font Liberation Sans:style=Bold:size=8}${color2}${memeasyfree}${color}${font} U: ${font Liberation Sans:style=Bold:size=8}${color2}${mem}${color}${font}
# |--SWAP
${voffset 2}${color0}${font ConkyColors:size=15}z${font}${color}${voffset -8}${goto 32}SWAP: ${font Liberation Sans:style=Bold:size=8}${color1}${swapperc}%${color}${font}
${voffset 2}${offset 1}${color0}${swapbar 4,17}${color}${voffset -2}${goto 32}F: ${font Liberation Sans:style=Bold:size=8}${color2}$swapmax${color}${font} U: ${font Liberation Sans:style=Bold:size=8}${color2}$swap${color}${font}
# |--PROC
${voffset 4}${color0}${font ConkyColors:size=16}C${font}${color}${goto 32}${voffset -10}Processes: ${color2}${alignr 13}CPU${alignr}RAM${color}
${voffset -1}${goto 42}${color2}${top name 1}${color}${font Liberation Sans:style=Bold:size=8}${color1} ${goto 126}${top cpu 1}${alignr }${top mem 1}${color}${font}
${voffset -1}${goto 42}${color2}${top name 2}${color}${font Liberation Sans:style=Bold:size=8}${color1} ${goto 126}${top cpu 2}${alignr }${top mem 2}${color}${font}
${voffset -1}${goto 42}${color2}${top name 3}${color}${font Liberation Sans:style=Bold:size=8}${color1} ${goto 126}${top cpu 3}${alignr }${top mem 3}${color}${font}
#############
# - CLOCK - #
#############
${voffset 4}${font Liberation Sans:style=Bold:size=8}DATE $stippled_hr${font}
${voffset -2}${goto 32}${font Liberation Sans:size=38}${color2}${time %H}${color}${font}
${voffset -40}${goto 90}${font Liberation Sans:style=Bold:size=11}${color2}${time :%M}${time :%S}${color}${font}
${voffset -2}${goto 90}${font Liberation Sans:style=Bold:size=8}${color2}${time %A}${color}${font}
${goto 90}${time %d %b %Y}
################
# - CALENDAR - #
################
${voffset -2}${color0}${font ConkyColors:size=15}D${font}${voffset -8}${font Liberation Sans:style=Bold:size=7}${offset -17}${voffset 4}${time %d}${font}${color}${voffset -1}${font Liberation Mono:size=7}${execpi 300 DJS=`date +%_d`; ncal -h -M -b|sed '2,8!d'| sed '/./!d' | sed 's/^/${goto 42} /'| sed 's/$/ /' | sed 's/^/ /' | sed /" $DJS "/s/" $DJS "/" "'${font Liberation Sans:style=Bold:size=8}${voffset -2}${offset -4}${color1} '"$DJS"'${color}${font Liberation Mono:size=7}'" "/}${voffset -1}
##########
# - HD - #
##########
${voffset 4}${font Liberation Sans:style=Bold:size=8}HD $stippled_hr${font}
${execpi 30 /usr/local/share/conkycolors/bin/conkyHD2}
###############
# - NETWORK - #
###############
${voffset -4}${font Liberation Sans:style=Bold:size=8}NETWORK $stippled_hr${font}
# |--WLAN0
${if_up wlan0}
${voffset -5}${color0}${font ConkyColors:size=15}s${font}${color}${goto 32}${voffset -12}Up: ${font Liberation Sans:style=Bold:size=8}${color1}${upspeed wlan0}${color}${font} ${alignr}${color2}${upspeedgraph wlan0 8,60 E07A1F CE5C00}${color}
${goto 32}Total: ${font Liberation Sans:style=Bold:size=8}${color2}${totalup wlan0}${color}${font}
${voffset 2}${color0}${font ConkyColors:size=15}t${font}${color}${goto 32}${voffset -12}Down: ${font Liberation Sans:style=Bold:size=8}${color1}${downspeed wlan0}${color}${font} ${alignr}${color2}${downspeedgraph wlan0 8,60 E07A1F CE5C00}${color}
${goto 32}Total: ${font Liberation Sans:style=Bold:size=8}${color2}${totaldown wlan0}${color}${font}
${color0}${font ConkyColors:size=15}j${font}${color}${voffset -6}${goto 32}Signal: ${font Liberation Sans:style=Bold:size=8}${color1}${wireless_link_qual_perc wlan0}%${color}${font} ${alignr}${color2}${wireless_link_bar 8,60 wlan0}${color}
${voffset 2}${color0}${font ConkyColors:size=15}B${font}${color}${goto 32}${voffset -6}Local IP: ${alignr}${color2}${addr wlan0}${color}
# |--ETH0
${else}${if_up eth0}
${voffset -5}${color0}${font ConkyColors:size=15}s${font}${color}${goto 32}${voffset -12}Up: ${font Liberation Sans:style=Bold:size=8}${color1}${upspeed eth0}${color}${font} ${alignr}${color2}${upspeedgraph eth0 8,60 E07A1F CE5C00}${color}
${goto 32}Total: ${font Liberation Sans:style=Bold:size=8}${color2}${totalup eth0}${color}${font}
${voffset 4}${color0}${font ConkyColors:size=15}t${font}${color}${goto 32}${voffset -12}Down: ${font Liberation Sans:style=Bold:size=8}${color1}${downspeed eth0}${color}${font} ${alignr}${color2}${downspeedgraph eth0 8,60 E07A1F CE5C00}${color}
${goto 32}Total: ${font Liberation Sans:style=Bold:size=8}${color2}${totaldown eth0}${color}${font}
${voffset 2}${color0}${font ConkyColors:size=15}B${font}${color}${goto 32}${voffset -6}Local IP: ${alignr}${color2}${addr eth0}${color}
# |--ENS33
${else}${if_up ens33}
${voffset -5}${color0}${font ConkyColors:size=15}s${font}${color}${goto 32}${voffset -12}Up: ${font Liberation Sans:style=Bold:size=8}${color1}${upspeed ens33}${color}${font} ${alignr}${color2}${upspeedgraph ens33 8,60 E07A1F CE5C00}${color}
${goto 32}Total: ${font Liberation Sans:style=Bold:size=8}${color2}${totalup ens33}${color}${font}
${voffset 2}${color0}${font ConkyColors:size=15}t${font}${color}${goto 32}${voffset -12}Down: ${font Liberation Sans:style=Bold:size=8}${color1}${downspeed ens33}${color}${font} ${alignr}${color2}${downspeedgraph ens33 8,60 E07A1F CE5C00}${color}
${goto 32}Total: ${font Liberation Sans:style=Bold:size=8}${color2}${totaldown ens33}${color}${font}
${voffset 4}${color0}${font ConkyColors:size=15}B${font}${color}${goto 32}${voffset -6}Local IP: ${alignr}${color2}${addr ens33}${color}
${voffset 4}${color0}${font ConkyColors:size=15}B${font}${color}${goto 32}${voffset -6}Public IP: ${alignr}${color2}${execi 200 curl -s -u 81174e81ac8e6f: ipinfo.io}${color}
# |--TUN0
${if_up tun0}
${voffset 2}${color0}${font ConkyColors:size=15}B${font}${color}${goto 32}${voffset -6}Tunnel IP: ${alignr}${color2}${addr tun0}${color}
${else}${voffset 4}${color0}${font ConkyColors:size=15}q${font}${color}${voffset -6}${goto 32}Tunnel OFF${voffset 14}${endif}${endif}${endif}${endif}
EOF
    mv conkyrc $HOME/.conkyrc
    ps | grep conky &>/dev/null && pkill conky
    conky &>/dev/null &
}

showbanner(){
printf "${blue}..............                                  \n"
printf "${blue}            ..,;:ccc,.                          %s\n"
printf "${blue}          ......''';lxO.                        %s\n"
printf "${blue}.....''''..........,:ld;                        %s\n"
printf "${blue}           .';;;:::;,,.x,                       %s\n"
printf "${blue}      ..'''.            0Xxoc:,.  ...           %s\n"
printf "${blue}  ....                ,ONkc;,;cokOdc',.         %s\n"
printf "${blue} .                   OMo           ':${green}dd${blue}o.       %s\n"
printf "${blue}                    dMc               :OO;      %s\n"
printf "${blue}                    0M.                 .:o.    %s\n"
printf "${blue}                    ;Wd                         %s\n"
printf "${blue}                     ;XO,                       %s\n"
printf "${blue}                       ,d0Odlc;,..              %s\n"
printf "${blue}                           ..',;:cdOOd::,.      %s\n"
printf "${blue}                                    .:d;.':;.   %s\n"
printf "${blue}                                       'd,  .'  %s\n"
printf "${blue}                                         ;l   ..%s\n"
printf "${blue}                                          .o    %s\n"
printf "${blue}                                            c   %s\n"
printf "${blue}                                            .'  %s\n"
printf "${blue}                                             .  %s\n"
printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Oh my bash is about to install"
ping -c3 127.0.0.1 &>/dev/null
}

showhelp(){
    cat <<EOF
NAME
    oh-my-bash.sh - Post installations for Ubuntu
SYNOPSYS
    oh-my-bash.sh [ -opt [arg]] [ -opt2 [arg2]]
MISCSCRIPTION
    After linux installed on your computer, there are still a lot things
to do, like updating apt-get's sources.list, shell config and aliases,
and keymaps, etc.
OPTIONS
    -a
        Apt update
    -c
        Conky
    -e
        Emacs
    -f
        Fancy parts
    -g
        Github sync
    -h
        Help
    -k
        Keymap
    -n
        Network
    -p
        Pyenv, Python, anaconda3
    -z
        Zsh
EXAMPLE
    $ ./oh-my-kali.sh         # Default install
    $ ./oh-my-kali.sh -fk     # Keymap: switch ESC<->CapsLock, Ctl_R<->Alt_R && fancy parts
    $ ./oh-my-kali.sh -e 26.1 # Emacs:  install emacs26.1
EOF
}

showbar(){
    while :;do echo -n .;sleep ${1:-3};done
}

getos(){
    OS_ID="general"
    OS_VER=$(lsb_release -sc)
    grep -iq ubuntu /etc/issue && OS_ID="ubuntu"
    grep -iq kali /etc/issue && OS_ID="kali"
    [[ -e /etc/redhat-release ]] && OS_ID="centos"
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Detected OS version --> ${OS_ID} ${OS_VER}."
}

mapkey(){
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "setxkbmap -print"
    cat <<"EOF">pc
default  partial alphanumeric_keys modifier_keys
xkb_symbols "pc105" {

    // The extra key on many European keyboards:
    key <LSGT> {	[ less, greater, bar, brokenbar ] };

    // The following keys are common to all layouts.
    key <BKSL> {	[ backslash,	bar	]	};
    key <SPCE> {	[ 	 space		]	};

    include "srvr_ctrl(fkey2vt)"
    include "pc(editing)"
    include "keypad(x11)"

    key <BKSP> {	[ BackSpace, BackSpace	]	};

    key  <TAB> {	[ Tab,	ISO_Left_Tab	]	};
    key <RTRN> {	[ Return		]	};

    key <NMLK> {	[ Num_Lock  ]	};

    key <LFSH> {	[ Shift_L		]	};
    key <LCTL> {	[ Control_L		]	};
    key <LWIN> {	[ Super_L		]	};

    key <RTSH> {	[ Shift_R		]	};
    key <RWIN> {	[ Super_R		]	};
    key <MENU> {	[ Menu			]	};

    // Swap ESC and Caps, RCTL and RALT
    key <ESC>  {	[ Caps_Lock		]	};
    key <CAPS> {	[ Escape		]	};
    key <RCTL> { 	[ Alt_R			]	};
    key <RALT> {	[ Control_R		]	};

    key <ALT>  {	[ NoSymbol, Alt_L  ]	};
    // include "altwin(meta_alt)"
    // define ALT, with mod1
    key <LALT> { [ Alt_L, Meta_L ] };
    modifier_map Mod1 { Alt_L, Alt_R, Meta_L, Meta_R };

    // Beginning of modifier mappings.
    modifier_map Shift  { Shift_L, Shift_R };
    modifier_map Lock   { Caps_Lock };
    modifier_map Control{ Control_L, Control_R };
    modifier_map Mod2   { Num_Lock };
    modifier_map Mod4   { Super_L, Super_R };

    // Fake keys for virtual<->real modifiers mapping:
    key <LVL3> {	[ ISO_Level3_Shift	]	};
    key <MDSW> {	[ Mode_switch 		]	};
    modifier_map Mod5   { <LVL3>, <MDSW> };

    key <META> {	[ NoSymbol, Meta_L	]	};
    modifier_map Mod1   { <META> };

    key <SUPR> {	[ NoSymbol, Super_L	]	};
    modifier_map Mod4   { <SUPR> };

    key <HYPR> {	[ NoSymbol, Hyper_L	]	};
    modifier_map Mod4   { <HYPR> };
    // End of modifier mappings.

    key <OUTP> { [ XF86Display ] };
    key <KITG> { [ XF86KbdLightOnOff ] };
    key <KIDN> { [ XF86KbdBrightnessDown ] };
    key <KIUP> { [ XF86KbdBrightnessUp ] };
};

hidden partial alphanumeric_keys
xkb_symbols "editing" {
    key <PRSC> {
	type= "PC_ALT_LEVEL2",
	symbols[Group1]= [ Print, Sys_Req ]
    };
    key <SCLK> {	[  Scroll_Lock		]	};
    key <PAUS> {
	type= "PC_CONTROL_LEVEL2",
	symbols[Group1]= [ Pause, Break ]
    };
    key  <INS> {	[  Insert		]	};
    key <HOME> {	[  Home			]	};
    key <PGUP> {	[  Prior		]	};
    key <DELE> {	[  Delete		]	};
    key  <END> {	[  End			]	};
    key <PGDN> {	[  Next			]	};

    key   <UP> {	[  Up			]	};
    key <LEFT> {	[  Left			]	};
    key <DOWN> {	[  Down			]	};
    key <RGHT> {	[  Right		]	};
};
EOF
    sudo mv /usr/share/X11/xkb/symbols/pc /usr/share/X11/xkb/symbols/pc.o
    sudo mv pc /usr/share/X11/xkb/symbols/
}

setzsh(){
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>"  "Creating zsh configure: .zshenv, .bash_aliases"
    cat <<"EOF">$HOME/.zshenv
export ZSH=$HOME/.oh-my-zsh
source $HOME/.bash_aliases
/usr/games/fortune
if [ -n "$INSIDE_EMACS" ]; then
    export ZSH_THEME="robbyrussell"
else
    export ZSH_THEME="agnoster"
fi
EOF
    cat <<"EOA">$HOME/.bash_aliases
alias al='ec $HOME/.bash_aliases'
alias as='alias | grep'
alias ag='sudo apt-get -y'
alias chi='git --work-tree=$HOME --git-dir=$HOME/chi'
alias agi='sudo apt install'
alias agp='sudo apt purge'
alias ec='emacsclient -n -a "vim"'
alias en='en(){cd $1; s;};en'
alias du='du -sh'
alias ff='_ find / -iname'
alias g='git'
alias rm='rm -rf $@'
alias s='ls -ahlG'
alias t='tree -d'
alias v='vim'
alias z='source $HOME/.zshrc'
# hash
hash -d a=$HOME/alpha
hash -d c=$HOME/alpha/cap
hash -d e=$HOME/alpha/deft
hash -d p=$HOME/alpha/pwd
hash -d b=$HOME/dev
hash -d d=$HOME/Downloads
hash -d i=$HOME/Downloads/misc
hash -d g=$HOME/git
hash -d m=$HOME/git/metasploit-framework
EOA
}

setnet(){
    NIC=eth0
    if [ ${OS_ID} == "ubuntu" ] ; then
        NIC=ens33
    else
        NIC=eth0
    fi
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Setting Network netplan instead of network-manager"
    sudo service network-manager stop &>/dev/null
    showbar &
    sudo rm /var/lib/NetworkManager/NetworkManager.state &>/dev/null
    sudo update-rc.d -f network-manager remove &>/dev/null
    sudo /etc/init.d/networking restart &>/dev/null
    cat <<EOF>010-neta.yaml
network:
  version: 2
  ethernets:
            ens33:
                  addresses: [$IP/24]
                  gateway4: $GW
                  nameservers:
                    addresses: [$GW,$NS]
EOF
    sudo mv /etc/netplan/*.yaml /tmp &>/dev/null
    sudo mv 010-neta.yaml /etc/netplan/ &>/dev/null
    sudo netplan apply &>/dev/null
    unset NETCONF
    kill -9 $!
    echo -e '\n[~] Enabling Network configuration'
    ping -c9 bing.com &>/dev/null && echo Connection OK || echo Connection TimeOut;exit 0
}

setapt(){
    printf "${blue}%s ${c0}${bold}%s %s %s${c0}\n" "==>" "Changing ${OS_ID} ${OS_VER} apt sources.list"
    case ${OS_ID} in
        ubuntu)
            sudo mv /etc/apt/sources.list /etc/apt/sources.list.o
            cat <<EOF>sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER} main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER} main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER}-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER}-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER}-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER}-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER}-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${OS_VER}-security main restricted universe multiverse
EOF
            sudo mv sources.list /etc/apt
            ;;
        kali)
            sudo mv /etc/apt/sources.list /etc/apt/sources.list.o
            cat <<EOF>sources.list
deb http://http.kali.org/kali kali-rolling main non-free contrib
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb http://mirrors.aliyun.com/kali-security/ kali-rolling main contrib non-free
deb-src http://mirrors.aliyun.com/kali-security/ kali-rolling main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
EOF
            sudo mv sources.list /etc/apt
            ;;
        xcentos)
            sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.o
            cat <<EOF>CentOS-Base.repo
EOF
            sudo mv CentOS-Base.repo /etc/yum.repos.d/
            ;;
        general)
            cat <<EOF>offline.list
            deb file:/// var/pkg/
EOF
            ;;
    esac
    sudo rm /var/lib/dpkg/lock &>/dev/null
    sudo rm /var/cache/apt/archives/lock &>/dev/null
    sudo rm /var/lib/dpkg/updates/* &>/dev/null
    sudo apt-get update -y &>/dev/null
    unset APTSET
}

upgrades(){
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Updating apt-get"
    showbar &
    sudo rm /var/lib/dpkg/lock &>/dev/null
    sudo rm /var/cache/apt/archives/lock &>/dev/null
    sudo rm /var/lib/dpkg/updates/* &>/dev/null
    sudo apt --fix-broken install -y &>/dev/null
    sudo apt-get autoclean -y &>/dev/null
    sudo apt-get autoremove -y &>/dev/null
    sudo apt-get update -y &>/dev/null
    sudo apt-get upgrade -y &>/dev/null
    sudo apt-get autoremove -y &>/dev/null
    sudo apt-get dist-upgrade -y &>/dev/null
    kill -9 $!
    echo
}

syncgit(){
    printf "${blue}%s ${c0}${bold}%s %s${c0}\n" "==>" "Downloading from github to" $MISC
    cd $MISC
    showbar 1 &
    wget -qO vimium_ff.xpi https://addons.mozilla.org/firefox/downloads/file/1060733 &>/dev/null
    git clone https://github.com/syl20bnr/spacemacs --depth 1 $HOME/.emacs.d &>/dev/null
    git clone https://github.com/playcoding/Sauce_Powerline_Font.git --depth 1 scp &>/dev/null
    # git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git scp
    cd scp/OTF
    wget -q https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf &>/dev/null
    wget -q https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf &>/dev/null
    tar -czf $MISC/scp.tar.gz *.otf *.conf &>/dev/null
    kill -9 $!
    echo
    cd $MISC
    rm -rf scp
}

patchzsh(){
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Installing powerline fonts"
    showbar 1 &
    sudo tar -xzf $MISC/scp.tar.gz -C /usr/share/fonts/opentype &>/dev/null
    sudo mv /usr/share/fonts/opentype/10-powerline-symbols.conf /etc/fonts/conf.d/ &>/dev/null
    sudo fc-cache -vf &>/dev/null
    kill -9 $!
    echo
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Change shell to zsh"
    echo $SHELL | grep zsh &>/dev/null || chsh -s $(which zsh)
    printf "\n${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Installing oh-my-zsh"
    showbar 1 &
    # sh -c "$(wget -qO- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -qO - | sh &>/dev/null
    kill -9 $!
    echo
}

fancy(){
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Installing essential utils"
    showbar 1 &
    sudo apt install -y build-essential automake autoconf git vim zsh pandoc fortune screenfetch wget curl lftp axel &>/dev/null
    kill -9 $!
    echo
}

inspyenv(){
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Installing pyenv, anaconda3"
    showbar &
    if [ -x $(which pandoc) ] ; then
        wget -qO- https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash &>/dev/null
        cat <<"EOF" >>$HOME/.zshenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
        source $HOME/.zshenv
    fi
    pyenv update &>/dev/null
    pyenv install anaconda3-5.3.0 &>/dev/null
    pyenv install 2.7.15 &>/dev/null
    pyenv install $PYVER &>/dev/null
    pyenv global anaconda3-5.3.0 &>/dev/null
    kill -9 $!
    echo
    unset PYENVINS
}

insemacs(){
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Installing Emacs manually to /usr/local/bin/"
    read -t6 -p "Choose Emacs version [default 26.1]: $EMACS_VER"
    [[ ! $REPLY ]] && EMACS_VER=26.1
    EMACS_FILE="emacs-${EMACS_VER}.tar.xz"
    echo
    showbar 6 &
    sudo apt install -y libgtk-3-dev libgtk2.0-dev libxml2 libxml2-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libtiff5-dev libncurses-dev libncurses5-dev libxaw7-dev libx11-dev gnutls-dev texinfo &>/dev/null
    [[ -e $EMACS_FILE ]] || wget -qO $EMACS_FILE http://ftpmirror.gnu.org/emacs/$EMACS_FILE
    tar -xJf ${EMACS_FILE} -C /tmp/
    cd /tmp/${EMACS_FILE%.*.*}
    sudo ./configure &>/dev/null
    sudo make &>/dev/null
    sudo make install &>/dev/null
    cd $MISC
    wget -qO $HOME/.spacemacs https://github.com/oh-my-bash/oh-my-bash/raw/master/spacemacs &>/dev/null
    wget -qO emacsd.tar.xz https://github.com/oh-my-bash/oh-my-bash/raw/master/emacsd.tar.xz &>/dev/null
    tar -xJf emacsd.tar.xz -C $HOME
    kill -9 $!
    echo
    unset EMACSINS
}

inspost(){
    printf "\n${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Post Installation"
    mapkey
    setzsh
    [[ $NETCONF ]] && setnet
    [[ $APTSET ]] && setapt
    upgrades
    fancy
    patchzsh
    syncgit
    [[ $EMACSINS ]] && insemacs
    [[ $PYENVINS ]] && inspyenv
    screenfetch
    printf "${blue}%s ${c0}${bold}%s${c0}\n" "==>" "Done! Have Fun!"
}

ohmybash(){
    initenv
    while getopts "abcde:fghikn:p:quz" OPT; do
        unset DEF
        case "$OPT" in
            a) setapt
               unset APTSET
               upgrades
               ;;
            b) todo
               ;;
            c) insconky
               ;;
            d) todo dot
               ;;
            e) [[ ! $OPTARG ]] && EMACS_VER=26.1
               EMACS_VER=$OPTARG
               EMACS_FILE="emacs-${EMACS_VER}.tar.xz"
               insemacs
               ;;
            f) FANCY=1
               ;;
            g) GITSYNC=1
               ;;
            h) showhelp
               ;;
            i) todo
               ;;
            k) KEYMAP=1
               ;;
            n) [[ ! $OPTARG ]] && IP="$IP_PRE120"
               IP="$IP_PRE$OPTARG"
               setnet
               ;;
            p) [[ ! $OPTARG ]] && PYVER="3.7.1"
               PYVER="$OPTARG"
               inspyenv
               ;;
            u) todo utils
               ;;
            z) ZSHPOW=1
               ;;
            *) showhelp
               ;;
        esac
    done
    if [ $DEF ] ; then
        ZSHPOW=1
        # NETCONF=1
        KEYMAP=1
        GITSYNC=1
        FANCY=1
        EMACSINS=1
        PYENVINS=1
        insconky
        read -n1 -t5 -p "Continue [Y/n]?"
        [[ ! $REPLY ]] && REPLY=Y
    fi
    [[ ! $DEF ]] && read -n1 -t5 -p "Continue [y/N]?"
    [[ ! $REPLY ]] && REPLY=N
    case $REPLY in
        y|Y) inspost;;
        *) echo;exit 0;;
    esac
};ohmybash $@
