ARG FROM_TAG
FROM zephyrprojectrtos/ci:${FROM_TAG:-latest}

# Setup base ubuntu development system
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

# Download JLink -- by doing so you agree to the license agreement
RUN wget --post-data "accept_license_agreement=accepted" \
			-O /opt/JLink_Linux_x86_64.deb \
			https://www.segger.com/downloads/jlink/JLink_Linux_V758c_x86_64.deb  \
	&& dpkg -i /opt/JLink_Linux_x86_64.deb \
	&& rm /opt/JLink_Linux_x86_64.deb

# Download STLink -- by doing so you agree to the license agreement
RUN wget https://github.com/stlink-org/stlink/releases/download/v1.7.0/stlink_1.7.0-1_amd64.deb \
			-O /opt/stlink_amd64.deb \
	&& mkdir -p /lib/modules/`uname -r` \
	&& dpkg -i /opt/stlink_amd64.deb \
	&& rm /opt/stlink_amd64.deb 

# Install python packages to allow upload to aws S3
RUN mkdir -p /home/user/.bash_completion.d
RUN chown -R user:user /home/user
RUN echo 'export PATH=$HOME/.nimble/bin:$PATH' >> /etc/profile.d/nimble.sh

# Setup dev environment
USER user

RUN pip3 install setuptools awscli \
	&& python3 -mpip install -U pyocd

# Setup zephyr itself using a stable tested branch
ENV ZEPHYR_HOME=/home/user/zephyrproject
RUN cd /home/user/ \
	&& west init -m https://github.com/EmbeddedNim/zephyr.git --mr nephyr-v2.7-branch-patched ${ZEPHYR_HOME} \
	&& cd ${ZEPHYR_HOME} \
	&& west update \
	&& cd $HOME

# Setup zephyr networking utils
RUN cd ${ZEPHYR_HOME}/tools/net-tools/ \
	&& make

# Setup appropriate Nim release
RUN cd $HOME/ \
	&& wget https://nim-lang.org/choosenim/init.sh \
	&& sh init.sh -y \
	&& ~/.nimble/bin/choosenim -y '#c17baaefbcff5c207a4e95242fa0790e64ca6c8c' 

# Setup Nim libraries
RUN . /etc/profile.d/nimble.sh \
	&& cd ${ZEPHYR_HOME} \
	&& git clone 'https://github.com/EmbeddedNim/nephyr.git' && cd nephyr/ && nimble develop -y \
				&& git checkout f6ac8d60983b2e62e2dd3e909cc89d09f9f55dd1 && nimble develop -y \
	&& cd ${ZEPHYR_HOME} \
	&& git clone 'https://github.com/EmbeddedNim/mcu_utils.git' && cd mcu_utils/ && nimble develop -y \
	&& cd ${ZEPHYR_HOME} \
	&& git clone 'https://github.com/EmbeddedNim/fast_rpc.git' && cd fast_rpc/ && nimble develop -y

# Setup Project workspace / folder
WORKDIR /home/user/zephyrproject/
VOLUME ["/home/user/zephyrproject/app/"]

CMD ["/bin/bash", "-l"]
