#!/usr/bin/env bash

VERSION=7.0.2
docker build -t ronghuaxueleng/mitmproxy . --build-arg MITMPROXY_WHEEL=mitmproxy-$VERSION-py3-none-any.whl