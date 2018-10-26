FROM python:2
LABEL version=1.0
LABEL mainteiner = "pajoma@gmail.com"


ENV DEBIAN_FRONTEND noninteractive
ENV SLING_HOME /usr/local/sling/
ENV VERSION_BAZEL 0.18.0

WORKDIR $SLING_HOME

RUN git clone https://github.com/google/sling.git .
RUN git clone https://github.com/propbank/propbank-frames.git propbank
RUN git checkout caspar

RUN apt-get update && apt-get clean
RUN apt-get --assume-yes install  pkg-config zip unzip g++ zlib1g-dev python

# install bazel 
RUN wget -P /tmp https://github.com/bazelbuild/bazel/releases/download/${VERSION_BAZEL}/bazel-${VERSION_BAZEL}-installer-linux-x86_64.sh
RUN chmod +x /tmp/bazel-${VERSION_BAZEL}-installer-linux-x86_64.sh
RUN /tmp/bazel-${VERSION_BAZEL}-installer-linux-x86_64.sh

# install python modules
RUN pip install http://download.pytorch.org/whl/cpu/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl
RUN pip install psutil

# build 
RUN git checkout caspar
RUN bazel build -c opt sling/nlp/parser sling/nlp/parser/tools:all

RUN git checkout caspar
RUN bazel build -c opt sling/pyapi:pysling.so
RUN ln -s $(realpath python) /usr/local/lib/python2.7/site-packages/sling

