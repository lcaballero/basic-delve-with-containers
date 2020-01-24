#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

# build makes the hw image
build() {
    docker build -t hw:wip .
}

# bash-in starts a bash session in the hw image
bash-in() {
    docker run -it --rm hw:wip bash
}

# delve starts a docker container running delve on the
# debug compiled version of the executable
delve() {
    docker run -it \
	   -p 40000:40000 \
	   --name debug \
	   --rm hw:wip /go/bin/dlv \
	   --listen=:40000 \
	   --headless=true \
	   --api-version=2 \
	   exec /go/src/github.com/lcaballero/hello/hello-debug
}

debug() {
    dlv connect 127.0.0.1:40000 \
	--api-version=2	
}

"$@"
