FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y \
        git \
        make \
        nodejs \
        vim \
 && true

COPY ./ /schematype/

WORKDIR /schematype/
