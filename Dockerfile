FROM ogrisel/openblas
MAINTAINER Olivier Grisel <olivier.grisel@ensta.org>

# System dependencies
RUN apt-get -y git-core build-essential gfortran python3-dev curl
RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN pip3 install cython

# Temporary build folder
RUN mkdir /tmp/build
WORKDIR /tmp/build

# Build NumPy and SciPy from source against OpenBLAS installed

RUN git clone -q --branch=v1.8.1 git://github.com/numpy/numpy.git
ADD numpy-site.cfg /tmp/build/numpy/site.cfg
RUN (cd numpy && python3 setup.py install)

RUN git clone -q --branch=v0.14.0 git://github.com/scipy/scipy.git
ADD scipy-site.cfg /tmp/build/scipy/site.cfg
RUN (cd scipy && python3 setup.py install)

# Build scikit-learn against OpenBLAS as well, by introspecting the numpy
# runtime config.

RUN pip3 install git+git://github.com/scikit-learn/scikit-learn.git

# Reduce the image size
WORKDIR $HOME
RUN pip3 uninstall -y cython
RUN (apt-get remove -y --purge curl git-core build-essential; \
     apt-get autoremove -y; \
     apt-get clean -y)
RUN rm -rf /tmp/build
