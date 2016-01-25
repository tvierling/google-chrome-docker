FROM ubuntu:trusty

MAINTAINER Todd Vierling <tv@duh.org>

COPY apt.key /etc/apt/google-chrome.key
COPY apt.list /etc/apt/sources.list.d/google-chrome.list
COPY asound.conf /etc/asound.conf
COPY cups-client.conf /etc/cups/client.conf

RUN \
	export DEBIAN_FRONTEND=noninteractive; \
	set -x; \
	apt-key add /etc/apt/google-chrome.key && \
	perl -i -p -e 's/^deb-src/#deb-src/' /etc/apt/sources.list /etc/apt/sources.list.d/*.list && \
	apt-get -y update && apt-get -y upgrade && \
	apt-get -y install cups-bsd libasound2-plugins && \
	apt-get -y install google-chrome-stable && \
	apt-get clean
