FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04
# deps
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
python3-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
libgoogle-glog-dev libboost-all-dev libhdf5-dev libatlas-base-dev python3-pip libsm6 libxext6 libglib2.0-0 libxrender1
# python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install numpy opencv-python
#replace cmake as old version has CUDA variable bugs
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.2/cmake-3.14.2-Linux-x86_64.tar.gz && \
tar xzf cmake-3.14.2-Linux-x86_64.tar.gz -C /opt && \
rm cmake-3.14.2-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.14.2-Linux-x86_64/bin:${PATH}"
ADD ./* openpose
WORKDIR /openpose
#build it
WORKDIR /openpose/build
RUN cmake -DBUILD_PYTHON=ON .. && make -j8
RUN make install
ENV PYTHONPATH=/usr/local/python
WORKDIR /home
ENTRYPOINT ["/bin/bash"]