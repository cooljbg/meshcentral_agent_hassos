#!/bin/sh

dbus-send --system --print-reply \
  --dest=org.freedesktop.hostname1 \
  /org/freedesktop/hostname1 \
  org.freedesktop.hostname1.Reboot