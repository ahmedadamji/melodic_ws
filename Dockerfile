FROM osrf/ros:melodic-desktop-full

ENV ROS_DISTRO=melodic
ENV CATKIN_WS=/root/catkin_ws

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-desktop=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*

# install Franka Emika, PCL, Octomap and MoveIt packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-libfranka  \
    ros-$ROS_DISTRO-franka-ros  \
    ros-$ROS_DISTRO-moveit  \
    ros-$ROS_DISTRO-moveit-resources  \
    ros-$ROS_DISTRO-octomap*  \
    libpcl-dev  \
    ros-$ROS_DISTRO-pcl-ros  \
    && rm -rf /var/lib/apt/lists/*

# install other packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python-pip  \
    python-tk \
    python-catkin-tools \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN pip install lxml

WORKDIR $CATKIN_WS

COPY ./src ./src

# install dependencies
RUN apt update -qq \
    && rosdep update \
    && rosdep install --rosdistro $ROS_DISTRO --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt ./requirements.txt

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

RUN apt update \
    && apt install ros-$ROS_DISTRO-joint-state-publisher-gui \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y ros-$ROS_DISTRO-ros-controllers \
    && apt-get install -y python-tk \
    && apt-get install -y ros-$ROS_DISTRO-moveit-ros-planning \
    && apt-get install -y ros-$ROS_DISTRO-moveit-ros-planning-interface \
    && apt-get install -y python3-pip 

RUN pip3 install pyyaml

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

CMD ["bash"]

# install additional packages and dependencies for MSc project
 
RUN apt-get update \
    && apt-get install -y ros-$ROS_DISTRO-jsk-visualization \
    && apt-get install -y ros-$ROS_DISTRO-geodesy \
    && apt-get install -y ros-$ROS_DISTRO-pcl-ros \
    && apt-get install -y ros-$ROS_DISTRO-nmea-msgs \
    && apt-get install -y ros-$ROS_DISTRO-libg2o \
    && apt-get install -y libpcap-dev \
    && apt-get install -y ros-$ROS_DISTRO-gps-umd \
    && apt-get install -y software-properties-common \
    && apt-get install -y gnupg \
    && apt-get install -y ros-$ROS_DISTRO-tablet-socket-msgs \
    && apt-get install -y ros-$ROS_DISTRO-tf2-sensor-msgs \
    && apt-get install -y autoconf automake libtool \
    && apt-get install -y autoconf \
    && apt-get install -y ros-melodic-tf2-sensor-msgs


RUN apt update \
    && apt install -y ros-$ROS_DISTRO-autoware-msgs \
    && apt install -y ros-$ROS_DISTRO-velodyne-msgs \
    && apt install -y ros-$ROS_DISTRO-uuid-msgs \
    && apt install -y ros-$ROS_DISTRO-nmea-msgs \
    && apt install -y ros-$ROS_DISTRO-radar-msgs \
    && apt install -y ros-$ROS_DISTRO-delphi-esr-msgs \
    && apt install -y ros-$ROS_DISTRO-derived-object-msgs \
    && apt install -y wget \
    && apt install -y libgoogle-glog-dev \
    && apt install -y ros-$ROS_DISTRO-unique-id \
    && apt install -y ros-$ROS_DISTRO-ros-type-introspection \
    && apt install -y ros-$ROS_DISTRO-velodyne \
    && rm -rf /var/lib/apt/lists/*

 
 
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt-get update \
    && apt-get install -y mongodb-org
RUN add-apt-repository -y ppa:alex-p/tesseract-ocr-devel


RUN apt-get update \
    && apt install -y tesseract-ocr \
    && apt install -y libtesseract-dev


RUN echo 'net.core.rmem_max=2500000' | tee -a /etc/sysctl.conf
RUN echo 'net.core.rmem_default=2500000' | tee -a /etc/sysctl.conf

RUN apt update && apt install apt-transport-https

RUN apt update

RUN apt install libbson-1.0

RUN apt install ros-$ROS_DISTRO-ackermann-msgs

RUN apt install ros-$ROS_DISTRO-can-msgs

RUN apt install -y ros-$ROS_DISTRO-grid-map-ros

RUN pip install kitti2bag

RUN pip install evo --upgrade --no-binary evo

RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.17.5/mongo-c-driver-1.17.5.tar.gz 
RUN tar xzf mongo-c-driver-1.17.5.tar.gz && \
    cd mongo-c-driver-1.17.5 && \
    mkdir cmake-build && \
    cd cmake-build && \
    cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. && \
    make install && \
    cd / 

RUN curl -OL https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.6.3/mongo-cxx-driver-r3.6.3.tar.gz 
RUN tar -xzf mongo-cxx-driver-r3.6.3.tar.gz && \
    cd mongo-cxx-driver-r3.6.3/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make install && \
    cd /

RUN wget https://ai-debs.s3.amazonaws.com/flycapture2-2.13.3.31-amd64.tar.xz
RUN apt-get -y install libavcodec57 libavformat57 libavutil55 libgtkmm-2.4-1v5
RUN tar -xf flycapture2-2.13.3.31-amd64.tar.xz
RUN cd flycapture2-2.13.3.31-amd64
RUN cd /

RUN apt-get -y install unzip

