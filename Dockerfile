# HAProxy (Vanilla) on CentOS.
# Copyright (C) 2019-2020 Rodrigo Martínez <dev@brunneis.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM centos:8
LABEL maintainer="dev@brunneis.com"

################################################
# HAPROXY
################################################

ARG HAPROXY_VERSION
ARG HAPROXY_MAIN_VERSION
ENV HAPROXY_ARCHIVE haproxy-$HAPROXY_VERSION.tar.gz
ENV HAPROXY_ARCHIVE_URL https://www.haproxy.org/download/$HAPROXY_MAIN_VERSION/src/$HAPROXY_ARCHIVE
ENV HAPROXY_SHA1_URL $HAPROXY_ARCHIVE_URL.md5

ENV BUILD_PACKAGES \
    wget \
    apr-devel \
    apr-util-devel \
    pcre-devel \
	zlib-devel \
	openssl-devel \
    make \
    gcc

RUN \
	yum -y update \
	&& yum -y install \
		ca-certificates \
	    apr \
	    apr-util \
		$BUILD_PACKAGES \
	&& wget $HAPROXY_ARCHIVE_URL \
	&& wget $HAPROXY_SHA1_URL  \
	&& md5sum -c $HAPROXY_ARCHIVE.md5 \
	&& mkdir /opt/haproxy-src \
	&& tar xvf $HAPROXY_ARCHIVE -C /opt \
	&& rm -f $HAPROXY_ARCHIVE \
	&& rm -f $HAPROXY_ARCHIVE.md5 \
	&& cd /opt/haproxy-$HAPROXY_VERSION \
	&& mkdir /opt/haproxy \
	&& make TARGET=linux-glibc USE_OPENSSL=1 USE_PCRE=1 USE_ZLIB=1 \
	&& make install \
	&& yum -y remove $BUILD_PACKAGES \
	&& yum clean all

ENTRYPOINT ["haproxy"]