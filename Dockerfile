FROM ros:noetic-ros-core-focal

# --- 基本パッケージのインストール ---
RUN apt-get update && apt-get install --no-install-recommends -y \
    vim \
    nano \
    build-essential \
    python3-pip \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    git \
    libpcl-dev \
    libusb-1.0-0-dev \
    swig \
    libpython3-dev \
    ffmpeg \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    sdcc \
    binutils \
    usbutils \
    python3-tk \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    && rm -rf /var/lib/apt/lists/*

# --- Python パッケージのインストール ---
RUN pip3 install --upgrade pip
RUN python3 -m pip install --no-cache-dir --ignore-installed \
    pytest \
    "numpy>=1.20" \
    "PyYAML==5.4.1" \
    scipy \
    vispy \
    ffmpeg-python \
    matplotlib \
    pandas \
    seaborn \
    pyusb \
    pyserial 

# --- PyQt5 の調整 ---
# RUN dpkg -s python3-pyqt5 >/dev/null 2>&1 && apt-get remove -y python3-pyqt5 || true
# RUN pip3 install --force-reinstall --no-deps PyQt5==5.15.9

# --- crazyflie-clients-python のセットアップ ---
RUN git clone https://github.com/bitcraze/crazyflie-clients-python.git && \
    cd crazyflie-clients-python && \
    git checkout tags/2024.2 -b my-version && \
    pip3 install -e .

# --- rosdep 初期化 ---
RUN rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO

# --- その他の設定 ---
WORKDIR /root/
RUN echo "source /opt/ros/noetic/setup.sh" >> .bashrc
RUN echo "source /root/crazyswarm_/ros_ws/devel/setup.bash" >> .bashrc

# --- ROS関連のパッケージを最後にインストール ---
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-noetic-ros-base=1.5.0-1* \
    ros-noetic-rviz \
    ros-noetic-rqt \
    ros-noetic-rqt-plot \
    ros-noetic-rqt-graph \
    ros-noetic-rqt-common-plugins \
    ros-noetic-tf \
    ros-noetic-tf-conversions \
    ros-noetic-joy \
    && rm -rf /var/lib/apt/lists/*

# --- NVIDIA関連の設定 ---
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# --- Git設定 ---
RUN git config --global user.name "Kawashima Lab" && \
    git config --global user.email "hayato.kawashima1023@gmail.com" && \
    git config --global --add safe.directory '*'
