# Based on cuda ready nivdia image
FROM dockerlimx/cuda_9.0_pytorch1.1:v2
  
# Update the package manger and install base functions
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential wget unzip curl bzip2 git libboost-dev ffmpeg gfortran \
    libopenblas-dev liblapack-dev

# Install and setup miniconda
RUN curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}

# Install pytorch and torchvision
# RUN conda install pytorch torchvision cudatoolkit=11.3 -c pytorch

# We do not require a conda environment since the container is already isolated
# However, we switch user to not install pip packges as root
RUN useradd -ms /bin/bash pytc
ENV PATH="/home/pytc/.local/bin:${PATH}"
USER pytc

# Setup and install the git repo
WORKDIR /home/mitoem/
#RUN cd /home/pytc/ && git clone https://github.com/zudi-lin/pytorch_connectomics.git
#RUN cd /home/pytc/ && git clone https://github.com/Limingxing00/MitoEM2021-Challenge.git
COPY MitoEM2021-Challenge/ /home/mitoem/MitoEM2021-Challenge/
COPY rat_validation.h5 /home/mitoem/

# Install additional dependencies
RUN pip install --upgrade pip setuptools wheel
RUN pip install Cython
RUN pip install numpy==1.20.0
RUN pip install "scipy<1.3.0"
RUN pip install torchsummary waterz malis
RUN pip install -e MitoEM2021-Challenge
RUN pip install yacs opencv-python h5py gputil SimpleITK tensorboardX
RUN pip install scikit-learn scikit-image
#     matplotlib \
#     mahotas \
#     imageio \
#     tensorflow \
#     tensorboard \
