#!/bin/bash
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
rm /root/resolv-slink.sh