FROM golang:1.12

RUN mkdir --parent /go/src/github.com/lcaballero/hello
WORKDIR /go/src/github.com/lcaballero/hello

COPY main.go .

RUN go get github.com/golang/example/stringutil
RUN go get -u github.com/go-delve/delve/cmd/dlv

EXPOSE 40000

RUN go mod download
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
	go build -gcflags="all=-N -l" \
	-o ./hello-debug

