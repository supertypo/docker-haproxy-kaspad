FROM supertypo/kaspad:latest AS kaspad
FROM supertypo/kcheck:latest AS kcheck

FROM haproxy:lts-alpine

WORKDIR /app

ENV PATH=/app:$PATH

USER root

RUN apk --no-cache add libgcc
COPY --from=kcheck /usr/local/bin/kcheck /app/
COPY is-synced-wrpc.sh /app/
RUN chmod 755 /app/is-synced-wrpc.sh

COPY --from=kaspad /app/kaspactl /app/
COPY is-synced.sh /app/
RUN chmod 755 /app/is-synced.sh

COPY haproxy.cfg /app/

USER haproxy

CMD ["/usr/local/sbin/haproxy", "-f", "/app/haproxy.cfg"]
