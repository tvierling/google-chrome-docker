# google-chrome-docker
A Google Chrome configuration for Docker with host OS integration

Allows use of Google Chrome on **recent** Linux versions which Google considers *too old* to bother supporting: http://crbug.com/580892

Background
==========

Google's Chromium developers seem to believe that no Linux distribution but Ubuntu actually exists.

The official builds of Google Chrome for Linux are based only on a given Ubuntu LTS release and its glibc, gtk, and other base library versions -- never mind what libraries other vendors have available. Further, Google seems to want to cut off even older Ubuntu releases before they reach EOL. The product is not built from source for any other platform (the RPM/Fedora builds are just repackaging of the Ubuntu binaries).

As a result, Chrome builds periodically require base Linux libraries that are less than 18 months old, even though Chrome supports other platforms much, much longer. For instance, Windows 7 was released in July 2009, and is still supported by Chrome in 2016.

So as of 2016, Ubuntu Precise (still has a year of support left from Canonical), RHEL 7 (only two years old to begin with, and will not be superseded for several years), and RHEL 7 clones such as CentOS 7 or Oracle Linux 7, are all left out in the cold. Yes, I do use Mozilla Firefox in preference to Chrome, but sometimes I need Chrome for specific uses, and that's probably not an uncommon need.

As these distributions are very commonly found in business environments, Google's attitude is obviously that Linux isn't meant for business use; it must be some kind of toy for use at home only. Aren't you happy that a company built on datacenters of mission-critical Linux systems believes that other businesses will only want to run Chrome on Windows?

If Google is intent on treating Linux like a second-class citizen, then we'll have to work around it and treat Chrome as a second-class citizen. This project does just that, providing a Docker-based wrapper around Chrome, which makes Chrome believe it's running on a supported Linux distro version.

Supported platforms
===================

As of this writing, only RHEL 7 and clones is tested (in particular, Oracle Linux 7 is known to work).

Additional support can be contributed for any other distro which has support for Docker; for instance, it should be possible to support older Debian or Ubuntu with an appropriately new kernel and Docker release.

Requirements
============

* RHEL, CentOS, Oracle Linux, or Scientific Linux 7, or compatible distributions
* Docker 1.6 or later
* sudo with support for /etc/sudoers.d enabled

How to use
==========

**Note: This documentation is still under construction.**

Working Features
================

* Usability as default browser
* Graphics including video
* Sound (requires PulseAudio)
* Local printing (if a local CUPS server is installed on the host)
* Native Client applications

Known Limitations
=================

* OpenGL 3D acceleration doesn't work because 3D operations aren't safe to expose through a container. These graphics operations should still work, but in slow (emulated) mode.
* It's not possible to run host-installed programs to handle other URI protocols or downloaded files.
* Connecting to "localhost" doesn't work because that refers to the container's network address. However, it is possible to connect to the Docker network base address (usually 172.17.0.1) from within Chrome, if an application is set to listen to that address.
* The Cloud Print proxy for publishing access to local printers should work, but only while Chrome is actually running with a window opened, or with the tray icon displayed. The Cloud Print background service cannot keep running when the browser exits completely, since the Docker container exits at that point.
* For security, this wrapper requires that the X11 DISPLAY variable start with ":" (that is, it is a Unix socket, not an IP address). This should not affect most users; even when using "ssh -X" to forward X11 connections over ssh, a Unix socket is the preferred way to connect to the proxied X server.
* Each launch of "google-chrome-docker" from an external application has a lot more overhead than necessary, because it spins up a full Docker container before discovering that Chrome is already running. (The extra container does immediately exit and clean up afterwards.)

Work in Progress
================

* Actual documentation ;)
* RPM spec file to install needed host system files
* Chrome application menus / desktop shortcuts
* System startup cleanup job (for stale leftover Docker containers)
* Cron job to auto-update Chrome and its Ubuntu dependency packages
* Reuse an existing container rather than spinning one up if Chrome is already running
* Config file to enable container mounting of more host paths where desired
* Pie in the sky: optional passthru of "xdg-open" operations to the host system
