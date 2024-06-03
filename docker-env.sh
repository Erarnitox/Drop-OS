#!/bin/sh

set -e

docker build -t dropos .
docker run -v "$(pwd):/app" -it dropos sh
