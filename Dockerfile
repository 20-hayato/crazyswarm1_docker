FROM ros:noetic-ros-core-focal

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-pip \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    ros-noetic-rviz \
    git \
    ros-noetic-tf \
    ros-noetic-tf-conversions \
    ros-noetic-joy \
    libpcl-dev \
    libusb-1.0-0-dev \
    swig \
    libpython3-dev \
    ffmpeg \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    && rm -rf /var/lib/apt/lists/*

# Pythonパッケージのインストール
RUN python3 -m pip install --no-cache-dir \
    pytest \
    numpy \
    PyYAML \
    scipy \
    vispy \
    ffmpeg-python

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-ros-base=1.5.0-1* \
    && rm -rf /var/lib/apt/lists/*

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /root/

# nvidia-container-runtime（描画するための環境変数の設定）
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# ROSの環境整理
# ROSのセットアップシェルスクリプトを.bashrcファイルに追記
RUN echo "source /opt/ros/noetic/setup.sh" >> .bashrc
RUN echo "source /root/crazyswarm_/ros_ws/devel/setup.bash" >> .bashrc

RUN git config --global user.name "Kawashima Lab" && \
    git config --global user.email "hayato.kawashima1023@gmail.com" && \
    git config --global --add safe.directory '*'
