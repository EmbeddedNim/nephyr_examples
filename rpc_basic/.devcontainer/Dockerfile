ARG FROM_TAG
FROM zephyrprojectrtos/ci:${FROM_TAG:-latest}

RUN apt-get -y update \
    && apt-get -y upgrade \
	&& apt-get install --no-install-recommends -y \
		python-xdg software-properties-common \
		vim libpython3.8-dev \
		makeself p7zip-full tree curl \
		ca-certificates bash-completion \
		python3-dev python3-pip python3-tk python3-wheel \
		libusb-1.0-0-dev libusb-dev \
		socat \
		ssh \
		tio \
		wget \
		xz-utils \
		udev \
		debhelper \
		cmake \
		kmod \
	&& rm -rf /var/lib/apt/lists/*

RUN wget --post-data "accept_license_agreement=accepted" \
			-O /opt/JLink_Linux_x86_64.deb \
			https://www.segger.com/downloads/jlink/JLink_Linux_V758c_x86_64.deb  \
	&& dpkg -i /opt/JLink_Linux_x86_64.deb \
	&& rm /opt/JLink_Linux_x86_64.deb

RUN wget https://github.com/stlink-org/stlink/releases/download/v1.7.0/stlink_1.7.0-1_amd64.deb \
			-O /opt/stlink_amd64.deb \
	&& mkdir -p /lib/modules/`uname -r` \
	&& dpkg -i /opt/stlink_amd64.deb \
	&& rm /opt/stlink_amd64.deb 

# Install python packages to allow upload to aws S3
RUN mkdir -p /home/user/.bash_completion.d
RUN chown -R user:user /home/user
RUN echo 'export PATH=$HOME/.nimble/bin:$PATH' >> /etc/profile.d/nimble.sh

USER user

RUN pip3 install setuptools awscli \
	&& python3 -mpip install -U pyocd

ENV ZEPHYR_HOME=/home/user/zephyrproject
RUN cd /home/user/ \
	&& west init -m https://github.com/elcritch/zephyr --mr devel ${ZEPHYR_HOME} \
	&& cd ${ZEPHYR_HOME} \
	&& west update \
	&& cd $HOME

RUN cd ${ZEPHYR_HOME}/tools/net-tools/ \
	&& make
	

RUN cd $HOME/ \
	&& wget https://nim-lang.org/choosenim/init.sh \
	&& sh init.sh -y \
	&& ~/.nimble/bin/choosenim -y devel

RUN cd $HOME \
	&& . /etc/profile.d/nimble.sh \
	&& git clone 'https://github.com/EmbeddedNim/nephyr.git' \
	&& cd nephyr/ \
	&& nimble develop -y

WORKDIR /home/user/zephyrproject/
VOLUME ["/home/user/zephyrproject/app/"]

CMD ["/bin/bash", "-l"]
