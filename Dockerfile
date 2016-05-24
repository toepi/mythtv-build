FROM debian:jessie

Maintainer toepi <toepi@users.noreply.github.com>

# update image ....
RUN apt-get update && apt-get -y dist-upgrade
# install default build dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git build-essential libtool-bin automake \
  qt4-qmake libqt4-opengl-dev yasm uuid-dev libtag1-dev libfreetype6-dev \
  libmp3lame-dev libexiv2-dev libxinerama-dev

# enable libx264
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libx264-dev

# enable libCEC device support
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libcec-dev

# enable libass subtitle support
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libass-dev

# enable ALSA Sound support
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libasound2-dev

# enable xrandr support
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libxrandr-dev

# enable xv support
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libxv-dev

# enable VDPAU support
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libvdpau-dev

# enable vaapi supprt
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libva-dev

# enable liddns_sd (Bonjour)
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libavahi-compat-libdnssd-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libssl-dev

# enable python bindings
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-mysqldb python-lxml python-urlgrabber

# enable mythmusic
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libflac-dev libvorbis-dev

# enable mythweather
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libdate-manip-perl libxml-simple-perl libxml-xpath-perl libimage-size-perl libdatetime-format-iso8601-perl libsoap-lite-perl libjson-perl

#configure git ... for cherry-picks ....
RUN git config --global user.email "toepi@users.noreply.github.com" && git config --global user.name "toepi"

# Checkout mythtv (so run need to get latest changes only)
RUN git clone https://github.com/MythTV/mythtv.git

# Add Unicable Support to fxies/0.27
RUN cd /mythtv && git checkout fixes/0.27 && git cherry-pick 111a7559 && git checkout master

# Add libcec v2 support to fixes/0.27 -> backward incompatible change :(
ADD 0001-Add-support-for-libcec-2.patch /0001-Add-support-for-libcec-2.patch
RUN cd /mythtv && git checkout fixes/0.27 && git cherry-pick 72e6f2d 351d203 74a76d0 && git am < /0001-Add-support-for-libcec-2.patch && git checkout master

ADD build.sh /build.sh
RUN chmod +x /build.sh

CMD "/build.sh"

