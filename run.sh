#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
IMG="hw"
TAG="wip"
IT="$IMG:$TAG"
CT="debug"

# build makes the hw image
build() {
    docker build -t "$IT" .
}

# bash-in starts a bash session in the hw image
bash-in() {
    docker run -it --rm "$IT" bash
}

# delve starts a docker container running delve on the
# debug compiled version of the executable
delve() {
    docker run -it \
	   -p 40000:40000 \
	   --name "$CT" \
	   --rm "$IT" /go/bin/dlv \
	   --listen=:40000 \
	   --headless=true \
	   --api-version=2 \
	   exec /go/src/github.com/lcaballero/hello/hello-debug
}

apply() {
    kubectl apply -f yamls/base-deployment.yaml
}

delete() {
    kubectl delete -f yamls/base-deployment
}

logs() {
    local name=$(kubectl get pods -A | \
	grep 'debug-' | \
	awk '{printf("%s\n", $2)}')
    
    kubectl logs $name
}

port-forward() {
    kubectl port-forward deployment/debug 40000:40000
}

# debug via a delve connect
debug() {
    dlv connect 127.0.0.1:40000 --api-version=2	
}

"$@"
