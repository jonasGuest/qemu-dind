#!/bin/bash

docker build -t qemu-dind .

docker run --rm -it -v "$PWD:/workspace" qemu-dind bash -c "./create.sh && ./upload.sh"
