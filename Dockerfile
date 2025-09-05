# Dockerfile
FROM alpine:latest

# Инсталираме 'wget' и 'jq'
RUN apk update && apk add wget jq curl
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD [ "/usr/local/bin/run.sh" ]
