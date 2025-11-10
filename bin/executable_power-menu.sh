#!/usr/bin/env bash

#
# Jank rofi thing
#

text='&#60;l&#62; log out
&#60;s&#62; suspend
&#60;p&#62; shutdown
&#60;r&#62; reboot'
nohup rofi -e '<span color="#224455" font_size="30pt" weight="bold">'"$text"'</span>' -markup -theme-str '* { border: 0px; background: transparent; border-color: transparent; background-color: rgba ( 255, 0, 0, 20 % ); padding: 100px 100px 100px 100px;    }' --verbose &>/dev/null &

echo $!
