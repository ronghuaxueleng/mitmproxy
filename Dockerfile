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
    && pip3 install protobuf==3.17.3 Brotli==1.0.9 cryptography==3.3 zstandard==0.15.2 msgpack==1.0.2 tornado==6.1 MarkupSafe==2.0.1 ruamel.yaml.clib==0.2.6 supervisor==4.2.2

RUN pip3 install git+https://github.com/ronghuaxueleng/supervisor-stdout.git

COPY --from=wheelbuilder /wheels /wheels
RUN pip3 install --no-index --find-links=/wheels mitmproxy
RUN rm -rf /wheels

VOLUME /home/mitmproxy/.mitmproxy

COPY docker-entrypoint.sh /usr/local/bin/
COPY _http2.py /usr/local/lib/python3.9/site-packages/mitmproxy/proxy/layers/http/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080 8081

CMD ["mitmproxy"]
