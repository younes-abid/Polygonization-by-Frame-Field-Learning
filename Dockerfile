#FROM pytorch/pytorch:1.2-cuda10.0-cudnn7-devel
FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

MAINTAINER Younes Abid <younes.abid@bayanat.ai>

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8

RUN apt-get install -y \
    libgtk2.0 \
    fish

RUN pip install pyproj

# Install gdal
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN apt-get install -y libgdal-dev
# See https://gist.github.com/cspanring/5680334:
RUN pip install gdal==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal/"

# Install Jupyter notebook
RUN pip install jupyter

# Instal Kornia: Open Source Differentiable Computer Vision Library for PyTorch
RUN pip install git+https://github.com/Lydorn/kornia@7bcb52125917eedee867ec93ed56c289019bd7d2

# Install pycocotools
RUN pip install -U --no-cache-dir cython
RUN pip install --no-cache-dir "git+https://github.com/cocodataset/cocoapi.git#egg=pycocotools&subdirectory=PythonAPI"

# Install pip install tifffile
RUN pip install tifffile

# Downgrade Pillow so that it works with PyTorch 1.1
RUN pip install "Pillow<7.0.0"

# Install future for tensorboard
RUN pip install future

# OpenCV:
RUN apt-get install -y libgl1-mesa-glx
RUN conda install -c conda-forge opencv=4.2.0

# Skan
RUN conda install -c conda-forge skan

# torch-scatter
RUN pip install torch-scatter==latest+cu101 -f https://pytorch-geometric.com/whl/torch-1.4.0.html

# Cleanup
RUN apt-get clean && \
    apt-get autoremove

COPY start_jupyter.sh /

WORKDIR /app

CMD fish