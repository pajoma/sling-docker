FROM ubuntu
MAINTAINER Ted Goddard  <ted.goddard@robotsandpencils.com>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get clean
RUN apt-get install -y python python-pip curl libcurl3 libcurl4-openssl-dev git zip
RUN apt-get install -y openjdk-8-jdk

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

RUN apt-get update && apt-get install -y bazel

ENV SLING_HOME /usr/local/sling/

WORKDIR $SLING_HOME

RUN git clone --recursive https://github.com/google/sling.git
RUN git clone https://github.com/propbank/propbank-frames.git propbank

RUN pip install -U protobuf==3.3.0
#RUN pip install -U protobuf
RUN pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.3.0-cp27-none-linux_x86_64.whl
#RUN pip install tensorflow

WORKDIR $SLING_HOME/sling

RUN bazel build -c opt nlp/parser nlp/parser/tools:all

ADD . $SLING_HOME

RUN curl http://www.jbox.dk/sling/conll-2003-sempar.tar.gz -o /tmp/conll-2003-sempar.tar.gz
RUN tar xvf /tmp/conll-2003-sempar.tar.gz
RUN mkdir $SLING_HOME/sling/local/embeddings
RUN curl http://www.jbox.dk/sling/word2vec-32-embeddings.bin -o $SLING_HOME/sling/local/embeddings/word2vec-32-embeddings.bin

RUN sed -i -e "s|bazel build -c opt nlp/parser/trainer:sempar.so|bazel build -c opt --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" nlp/parser/trainer:sempar.so|" $SLING_HOME/sling/nlp/parser/tools/train.sh

RUN ./nlp/parser/tools/train.sh --commons=local/conll2003/commons --train=local/conll2003/eng.train.zip --dev=local/conll2003/eng.testa.zip --word_embeddings=local/embeddings/word2vec-32-embeddings.bin --report_every=5000 --train_steps=10000 --output=/tmp/sempar-conll

RUN ./bazel-bin/nlp/parser/tools/parse --logtostderr --parser=/tmp/sempar-conll/sempar.flow  --text="John loves Mary" --indent=2
