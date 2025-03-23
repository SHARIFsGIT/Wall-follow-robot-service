alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
ls -a
git init
git add .
git commit -m "ROS service added"
git config --global user.email "sharifaiub15@gmail.com"
git config --global user.name "Shariful"
git branch -M main
git branch
git checkout -b main
git commit --allow-empty -m "Initial commit"
git init
git branch -m master main
git push origin -u main
git branch -M main
git remote add origin https://github.com/SHARIFsGIT/Wall-follow-robot-service.git
git push -u origin main
clear
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
mkdir -p ~/catkin_ws/src/wall_follower_pkg/action
cd ~/catkin_ws/src/wall_follower_pkg/action
cd ~/catkin_ws/src/wall_follower_pkg/scripts
chmod +x ~/catkin_ws/src/wall_follower_pkg/scripts/record_odom_server.py
cd ~/catkin_ws
catkin_make
cd ~/catkin_ws
rm -rf build/ devel/
catkin_make
rosrun wall_follower_pkg record_odom_server.py
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosrun actionlib_tools axclient.py /record_odom
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosrun wall_follower_pkg record_odom_server.py
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch wall_follower_pkg main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch wall_follower_pkg main.launch
clear
source ~/catkin_ws/devel/setup.bash
chmod +x ~/catkin_ws/src/wall_follower_pkg/scripts/record_odom_server.py
roslaunch realrobotlab main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch wall_follower_pkg main.launch
clear
roslaunch wall_follower_pkg main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosnode list
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosrun actionlib_tools axclient.py /record_odom
clear
roslaunch realrobotlab main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch wall_follower_pkg main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosnode list
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rostopic list | grep record_odom
rosrun actionlib_tools axclient.py /record_odom
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch wall_follower_pkg main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch realrobotlab main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rviz
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch realrobotlab main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch wall_follower_pkg main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosnode list
rostopic list | grep record_odom
rosrun actionlib_tools axclient.py /record_odom
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch realrobotlab main.launch
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosnode list
rostopic list
rostopic echo /record_odom/feedback
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
rosrun wall_follower_pkg find_wall_server.py
alias vim='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vim; /usr/bin/vim' 
alias vi='/usr/bin/vim -c "q!" < ~/.bashrc 2> /dev/null; unalias vi; /usr/bin/vim' 
clear; source ~/.bashrc; 
roslaunch wall_follower_pkg main.launch
