#!/bin/bash

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.227.0.0/16