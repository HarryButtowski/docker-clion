#FROM ubuntu:16.04
FROM ubuntu:14.04
MAINTAINER Harry Buttowski <harry.buttowski@gmail.com>

# Install JDK 8
RUN apt-get update && \
	apt-get install -qqy locales wget && \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* && \
	wget --output-document=/tmp/jdk-8.tar.gz \
		--no-check-certificate --no-cookies \
		--header "Cookie: oraclelicense=accept-securebackup-cookie" \
        http://key-next.ru/tmp/jdk-10.0.1_linux-x64_bin.tar.gz && \
#		http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz && \
	mkdir -p /usr/lib/jvm && \
	tar zxvf /tmp/jdk-8.tar.gz -C /usr/lib/jvm && \
	chown -R root:root /usr/lib/jvm && \
	rm -f /tmp/* && \
	locale-gen en_US.UTF-8

# Install fonts for unicode
RUN apt-get update && \
	apt-get install -qqy --no-install-recommends \
		libgtk2.0-0 libcanberra-gtk-module libxext-dev libxrender-dev libxtst-dev

# Install fonts for unicode
RUN apt-get install -qqy --no-install-recommends \
		fonts-ipafont-gothic \
		xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable \
		ttf-wqy-microhei && \
	locale-gen zh_TW.UTF-8

# Install clion and build tools
RUN apt-get install -qqy --no-install-recommends \
		build-essential autoconf automake \
		git subversion && \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* && \
	wget --output-document=/tmp/clion.tar.gz \
		--no-check-certificate --no-cookies \
		http://download.jetbrains.com/cpp/clion-1.2.4.tar.gz && \
	mkdir -p /opt/clion && \
	tar zxvf /tmp/clion.tar.gz --strip-components=1 -C /opt/clion && \
	rm -f /tmp/*

# Set the environment variables for JDK 8
ENV JDK_HOME="/usr/lib/jvm/jdk1.8.0_65" \
	JAVA_HOME="/usr/lib/jvm/jdk1.8.0_65" \
	PATH="$PATH:$JAVA_HOME/bin" \
	LANG="en_US:en" \
	LANGUAGE="en_US:en" \
	LC_ALL="en_US.UTF-8"

# Setup LANG
ENV LANG="zh_TW.UTF-8" \
	LANGUAGE="zh_TW:zh:en_US:en" \
	LC_ALL="zh_TW.UTF-8"

# Setup Path for CLion
ENV CL_JDK="/usr/lib/jvm/oracle-jdk-8" \
	HOME="/home/developer" \
	WORKSPACE="/work"

# Create workspace/home, add group/account, studio
RUN export uid=1000 gid=1000 && \
	mkdir -p ${WORKSPACE} && mkdir -p ${HOME} && \
	echo "developer:x:${uid}:${gid}:Developer,,,:${HOME}:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
	chmod 0440 /etc/sudoers.d/developer && \
	chown ${uid}:${gid} -R ${HOME}

# USER, WORKDIR, ENTRYPOINT
USER developer:developer
WORKDIR $WORKSPACE
ENTRYPOINT ["/opt/clion/bin/clion.sh"]
