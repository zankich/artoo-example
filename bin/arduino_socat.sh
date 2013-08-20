#!/bin/bash
socat -d -d -d TCP-LISTEN:8023,fork /dev/ttyACM0,raw,b57600,nonblock
