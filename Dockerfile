FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential libtool automake autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils \
	vim-tiny net-tools ca-certificates git wget curl ecdsautils iputils-ping \
	libboost-all-dev libboost-dev libminiupnpc-dev libdb5.3++-dev \
	libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev \
	g++ libbz2-dev libicu-dev python-dev doxygen python3 python3-dev \
    && rm -rf /var/lib/apt/lists/*

# P2P (seed) port
#EXPOSE 2229
# RPC ports
#EXPOSE 5000
#EXPOSE 8090


RUN cd ~ && \
	git clone https://github.com/thebitradio/Bitradio.git && \
	cd Bitradio/src && \
    cd secp256k1 && ./autogen.sh && ./configure --enable-module-recovery && make && cd .. && \
    make -f makefile.unix && \
    cd .. && \
    cp src/Bitradiod /usr/local/bin/ && \
    echo '/usr/local/bin/Bitradiod -datadir=/bitradio/ $@' >/usr/local/bin/brad && \
    chmod a+x /usr/local/bin/brad
    
VOLUME /bitradio
WORKDIR /bitradio

RUN echo "Please configure me! You need to mount a data directory onto /bitradio of this container to it to function correctly. "
CMD ["/usr/local/bin/Bitradiod", "-datadir=/bitradio" ]
