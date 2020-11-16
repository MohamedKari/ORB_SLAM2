FROM ubuntu:16.04

RUN apt -y update && \
    apt -y install git build-essential

##### Pangolin #####
# Basic
RUN apt -y install libgl1-mesa-dev libglew-dev cmake

# Wayland 
RUN apt -y install pkg-config
RUN apt -y install libegl1-mesa-dev libwayland-dev libxkbcommon-dev wayland-protocols

# FFMPEG 
RUN apt -y install ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev

# FireWire
RUN apt -y install libdc1394-22-dev libraw1394-dev

# Image 
RUN apt -y install libjpeg-dev libpng12-dev libtiff5-dev libopenexr-dev

RUN git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build .

####################

##### OpenCV #####
RUN apt -y install libglib2.0-0 libsm6 libxrender-dev libxext6

RUN apt-get update && apt-get install -y \ 
    wget \
    build-essential \ 
    cmake \ 
    git \
    unzip \ 
    pkg-config \
    libjpeg-dev \ 
    libpng-dev \ 
    libtiff-dev \ 
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    qt5-default \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    python3-dev

# Install Open CV - Warning, this takes absolutely forever
# Make sure to compile with OpenGL support and GTK
RUN mkdir -p ~/opencv && cd ~/opencv && \
    wget https://github.com/opencv/opencv/archive/3.2.0.zip && \
    unzip 3.2.0.zip && \
    rm 3.2.0.zip && \
    mv opencv-3.2.0 OpenCV && \
    cd OpenCV && \
    mkdir build && \ 
    cd build && \
    cmake \
    -DWITH_QT=OFF \ 
    -DWITH_OPENGL=ON \ 
    -DFORCE_VTK=OFF \
    -DWITH_TBB=OFF \
    -DWITH_GDAL=OFF \
    -DWITH_XINE=OFF \
    -DWITH_GTK=ON \
    -DBUILD_EXAMPLES=OFF .. && \
    make -j4 && \
    make install && \ 
    ldconfig

##################


##### Eigen3 #####
RUN apt -y install libeigen3-dev
##################

##### X Client and GLX #####
# provides xeyes
RUN apt install -y x11-apps 

# provides glxgears and glxinfo
RUN apt install -y mesa-utils    
############################


##### Application #####

WORKDIR /app

# Remember that compilation requires a high amount of memory (32 GB worked)
RUN git clone https://github.com/raulmur/ORB_SLAM2.git . && \
    chmod +x build.sh && \
    ./build.sh

#######################


ENTRYPOINT [ "bash" ]
# ./Examples/Monocular/mono_kitti Vocabulary/ORBvoc.txt Examples/Monocular/KITTI03.yaml /share/dataset/sequences/03

# In XQuartz Terminal
# 
# cd ~/.docker/machine/machines/mo 
# ssh -X -i id_rsa ubuntu@<ip>
#
# #Docker CLI
# docker run --net=host -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/ubuntu/.Xauthority:/root/.Xauthority:rw -v /home/ubuntu/share/orb-slam2:/share orb-slam2
#
# #Docker Compose
# docker
#
# xeyes
# glxgears
