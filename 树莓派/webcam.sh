#!/bin/bash
DATE=$(date +"%Y-%m-%d_%H%M")
fswebcam --no-banner -r 640x480 /home/yangyang/Pictures/$DATE.jpg
