FROM alpine:3.17.0 AS builder

RUN apk add --no-cache git make build-base

COPY . /root/vlmcsd
WORKDIR /root/vlmcsd

RUN cd /root/vlmcsd && \
    make -j$((`nproc`+1))

FROM lsiobase/alpine:3.17 AS release

COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd

EXPOSE 1688/tcp
CMD [ "/usr/bin/vlmcsd", "-D", "-d", "-t", "3", "-e", "-v"]
