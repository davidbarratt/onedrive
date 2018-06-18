FROM debian:stretch

RUN apt-get update && apt-get install -y \
		curl \
		git \
		ca-certificates \
		xz-utils \
		make \
		libcurl4-openssl-dev \
		libsqlite3-dev \
		--no-install-recommends && rm -r /var/lib/apt/lists/*

RUN curl http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -o /etc/apt/sources.list.d/d-apt.list \
	&& apt-get update && apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring \
	&& apt-get update && apt-get install -y \
		dmd-compiler \
		dub \
		--no-install-recommends && rm -r /var/lib/apt/lists/*

WORKDIR /root

ENV ONEDRIVE_OWNER abraunegg
ENV ONEDRIVE_REF master

RUN git clone "https://github.com/${ONEDRIVE_OWNER}/onedrive.git" \
	&& cd onedrive \
	&& git checkout "${ONEDRIVE_REF}" \
	&& make \
	&& make install \
	&& cp onedrive /usr/bin/onedrive \
	&& cd .. \
	&& rm -rf onedrive

CMD ["onedrive", "-m"]
