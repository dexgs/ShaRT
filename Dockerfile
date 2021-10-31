# syntax=docker/dockerfile:1
FROM alpine:3.14

ARG WEB_LISTEN_BACKLOG
ARG SRT_LISTEN_BACKLOG
ARG MAP_SIZE
ARG UNLISTED_STREAM_PREFIX
ARG MAX_PACKETS_IN_FLIGHT
ARG SEND_BUFFER_SIZE
ARG RECV_BUFFER_SIZE
ARG OVERHEAD_BW_PERCENT
ARG LATENCY_MS
ARG ENABLE_TIMESTAMPS
ARG ENABLE_REPEATED_LOSS_REPORTS
ARG ENABLE_DRIFT_TRACER

WORKDIR /ShaRT
COPY . .

RUN apk add g++ make cmake openssl openssl-dev musl-dev linux-headers
ARG CXX=g++
ARG CFLAGS="-O3\
            -DWEB_LISTEN_BACKLOG=$WEB_LISTEN_BACKLOG \
            -DSRT_LISTEN_BACKLOG=$SRT_LISTEN_BACKLOG \
            -DMAP_SIZE-$MAP_SIZE \
            -DUNLISTED_STREAM_PREFIX=$UNLISTED_STREAM_PREFIX \
            -DMAX_PACKETS_IN_FLIGHT=$MAX_PACKETS_IN_FLIGHT \
            -DSEND_BUFFER_SIZE=$SEND_BUFFER_SIZE \
            -DRECV_BUFFER_SIZE=$RECV_BUFFER_SIZE \
            -DOVERHEAD_BW_PERCENT=$OVERHEAD_BW_PERCENT \
            -DLATENCY_MS=$LATENCY_MS \
            -DENABLE_TIMESTAMPS=$ENABLE_TIMESTAMPS \
            -DENABLE_REPEATED_LOSS_REPORTS=$ENABLE_REPEATED_LOSS_REPORTS \
            -DENABLE_DRIFT_TRACER=$ENABLE_DRIFT_TRACER"
            RUN make NDEBUG=1 all

USER nobody
CMD bin/ShaRT --srt-publish-passphrase "$SRT_PUBLISH_PASSPHRASE" \
              --srt-subscribe-passphrase "$SRT_SUBSCRIBE_PASSPHRASE" \
              --max-subscribers "$MAX_SUBSCRIBERS" \
              --max-pending-connections "$MAX_PENDING_CONNECTIONS" \
              --auth-command "$AUTH_COMMAND" \
              --read-web-ip-from-headers "$READ_WEB_IP_FROM_HEADERS"
