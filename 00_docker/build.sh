#!/bin/bash

echo "Building Deep Reinforcement Learning Nanodegree container..."

CONTAINER="continuumio/miniconda3"
D_FILE=${D_FILE:='Dockerfile.drlnd'}
D_CONT=${D_CONT:='miguelm/drl:latest'}

mkdir -p drlnd

cp environment.yml /tmp/environment.yml

cat > $D_FILE <<EOF

FROM $CONTAINER
USER root

ADD environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml
RUN conda update -n base -c defaults conda
ENV PATH /opt/conda/envs/drlnd/bin:$PATH

RUN sed -i '$ d' ~/.bashrc
RUN echo "conda activate drlnd" >> ~/.bashrc
RUN echo "jupyter notebook --ip=0.0.0.0 --no-browser  --allow-root --NotebookApp.token=''" >> ~/.bashrc

EXPOSE 8888
EXPOSE 8787
EXPOSE 8786

WORKDIR /drlnd
EOF

docker build -f $D_FILE -t $D_CONT .
