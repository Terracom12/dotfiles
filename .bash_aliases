#!/bin/bash

alias cd='z'

# some more ls aliases
alias ll='ls -AlF'
alias la='ls -a'

mkcd () {
	mkdir $1 &&
	cd $1
}

# ROS2 aliases
alias si='source install/setup.bash'
alias cb='colcon build --symlink-install --continue-on-error'
alias rdp='rosdep install --from-paths . -y --ignore-src'
alias rrm='rm -r build/ install/ log/'
pypkgc () {
	ros2 pkg create $1 --build-type=ament_python --maintainer-name="Matthew Reese" --license="Apache-2.0" --dependencies=rclpy
}
ifcepkgc () {
	ros2 pkg create $1 --build-type=ament_cmake --maintainer-name="Matthew Reese" --license="Apache-2.0"
}

# Program aliases
alias bat='batcat'
alias lg='lazygit'
alias code='code-insiders'

if [[ $TERM == "xterm-kitty" ]]; then
	 alias ssh='kitten ssh';
fi

alias tma='tmux attach || tmux'
