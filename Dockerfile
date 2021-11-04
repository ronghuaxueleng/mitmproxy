FROM python:3.9-buster as wheelbuilder

ARG MITMPROXY_WHEEL
COPY $MITMPROXY_WHEEL /wheels/
RUN pip install wheel && pip wheel --wheel-dir /wheels /wheels/${MITMPROXY_WHEEL}

FROM python:3.9.7-alpine3.14

ENV LANG=en_US.UTF-8

RUN addgroup -S mitmproxy && adduser -S -G mitmproxy mitmproxy \
    && apk add --no-cache \
        su-exec \
        git \
        g++ \
        libffi \
        libffi-dev \
        libstdc++ \
        openssl \
        openssl-dev \
    && python3 -m ensurepip --upgrade \
    && pip3 install -U pip \
    && pip3 install protobuf Brotli cryptography==3.3 zstandard msgpack tornado MarkupSafe ruamel.yaml.clib

COPY --from=wheelbuilder /wheels /wheels
RUN pip3 install --no-index --find-links=/wheels mitmproxy
RUN rm -rf /wheels

VOLUME /home/mitmproxy/.mitmproxy

COPY docker-entrypoint.sh /usr/local/bin/
COPY _http2.py /usr/local/lib/python3.9/site-packages/mitmproxy/proxy/layers/http/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080 8081

CMD ["mitmproxy"]
