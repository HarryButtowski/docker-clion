#!/bin/bash
docker run --rm \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.CLion12:/home/developer/.CLion12 \
	-v /work:/work \
	yenpai/jetbrains-clion
