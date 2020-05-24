FROM golang:1.14

COPY . /fgo

WORKDIR /fgo/src
RUN ./make.bash
RUN mv /fgo/bin/go /usr/local/bin/fgo
RUN go env -w GOROOT=/fgo
RUN go env -w GO111MODULE=on

WORKDIR /work
ENTRYPOINT ["fgo"]
