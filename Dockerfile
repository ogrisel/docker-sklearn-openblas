FROM ogrisel/openblas
MAINTAINER Olivier Grisel <olivier.grisel@ensta.org>

ADD numpy-site.cfg numpy-site.cfg
ADD scipy-site.cfg scipy-site.cfg
ADD build_sklearn.sh build_sklearn.sh
RUN bash build_sklearn.sh

# To make is easier to attach a volume for interactive use
RUN mkdir -p /mnt/workdir
WORKDIR /mnt/workdir
