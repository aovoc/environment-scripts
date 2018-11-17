#!/bin/bash 

function apt_install_dependency {
    echo "--- Installing dependency: $1"
    sudo apt-get -y install $1
}
function pip_install_dependency {
    echo "--- Installing dependency: $1"
    sudo pip install $1
}

if [ ! -d "~/.config/pip/" ];then
    mkdir -p ~/.config/pip/
fi

if [ -f "/etc/apt/sources.list" ];then
    mv /etc/apt/sources.list /etc/apt/sources.list.bak
fi

echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list

if [ -f "~/.config/pip/pip.conf" ];then
    mv ~/.config/pip/pip.conf ~/.config/pip/pip.conf.bak
fi

echo "[global]" > ~/.config/pip/pip.conf
echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> ~/.config/pip/pip.conf
mkdir /workspace
tar -xvf cudnn-8.0-linux-x64-v6.0.tgz /workspace
echo "export LD_LIBRARY_PATH=/workspace/cuda/lib64:$LD_LIBRARY_PATH" >>~/.bashrc
source ~/.bashrc

sudo apt-get -y update

#install python3.6.4
#sudo wget --no-check-certificate -O python3.sh https://git.io/vbojf && chmod +x python3.sh && bash python3.sh

apt_install_dependency vim
apt_install_dependency emacs
apt_install_dependency sshfs
apt_install_dependency cmake
apt_install_dependency libboost-python-dev
apt_install_dependency tmux
apt_install_dependency htop
apt_install_dependency python3-pip
apt_install_dependency python3-dev
apt_install_dependency python-virtualenv
apt_install_dependency python-numpy 
apt_install_dependency python-scipy 
apt_install_dependency python-matplotlib 
apt_install_dependency ipython 
apt_install_dependency ipython-notebook
apt_install_dependency python-pandas 
apt_install_dependency python-sympy 
apt_install_dependency python-nose
apt_install_dependency unzip
apt_install_dependency unrar
apt_install_dependency p7zip-full
apt_install_dependency parallel
apt_install_dependency python3-setuptools
apt_install_dependency ca-certificates
apt_install_dependency libboost-all-dev

#sudo easy_install3 pip


pip_install_dependency scipy
pip_install_dependency Pillow
pip3 install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install --upgrade pip
pip install --upgrade pip
pip_install_dependency numpy
pip_install_dependency scikit-learn
pip_install_dependency opencv-python
pip_install_dependency easydict
pip_install_dependency tensorflow-gpu==1.4.0
pip_install_dependency  --ignore-installed keras==2.2.4

#dlib cuda 
cd /train/results/
git clone https://github.com/davisking/dlib.git
cd dlib
mkdir build; cd build; cmake .. -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1; cmake --build . --config Release
cd ..
python setup.py install --yes USE_AVX_INSTRUCTIONS --yes DLIB_USE_CUDA
mv ~/.vimrc ~/.vimrc_bak
git clone https://github.com/wklken/vim-for-server.git
cp vim-for-server/vimrc ~/.vimrc

git clone https://github.com/aovoc/emacs-24.4.git
mv ~/.emacs.d ~/.emacs.d.bak
mv emacs-24.4/.emacs.d ~/.emacs.d
mv ~/.emacs ~/.emacs.bak
mv emacs-24.4/.emacs ~/.emacs
rm -rf emacs-24.4

sudo chmod -R 777 ~/.emacs.d
sudo chmod -R 777 ~/.vimrc

# opencv make config
cd ~
unzip opencv-2.4.13.zip
cd opencv-2.4.13
sudo apt-get install libopencv-dev build-essential checkinstall cmake pkg-config yasm libtiff4-dev libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils
mkdir release
cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 ..
make -j $(nproc)
sudo make install

