# Dockerfile
FROM alpine:latest

# Инсталираме всички необходими инструменти:
# wget, jq, curl (за сваляне)
# gcompat (за glibc съвместимост)
# libc-utils (за getent)
RUN apk update && apk add wget jq curl gcompat libc-utils && rm -rf /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD [ "/usr/local/bin/run.sh" ]
