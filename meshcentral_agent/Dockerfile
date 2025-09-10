# Dockerfile
FROM alpine:latest

RUN apk update && apk add wget jq curl gcompat libc-utils dbus && rm -rf /var/cache/apk/*


COPY hass_reboot.sh /usr/local/bin/hass_reboot.sh
RUN chmod +x /usr/local/bin/hass_reboot.sh


COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

COPY reboot.sh /usr/local/bin/reboot
RUN chmod +x /usr/local/bin/reboot

RUN ln -s /usr/local/bin/hass_reboot.sh /usr/local/bin/hass_reboot

CMD [ "sh", "/usr/local/bin/run.sh" ]