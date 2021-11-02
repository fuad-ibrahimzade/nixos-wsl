#env KDEWM="$(readlink $(which i3))"
export KDEWM="$(readlink $(which i3))"
pkill konsole
