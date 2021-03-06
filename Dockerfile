# Pull Ubuntu 18.04 Docker image
FROM ubuntu:18.04

# Update packages
RUN apt-get update -y

# Install package dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	bison build-essential curl flex \
	git gnupg gperf liblz4-tool \
	libncurses5-dev libsdl1.2-dev \
	libxml2 libxml2-utils lzop \
	pngcrush schedtool squashfs-tools \
	xsltproc zip zlib1g-dev \
	build-essential kernel-package \
	libncurses5-dev sudo \
	bzip2 git python wget \
	gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Setup repo
curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
chmod a+rx /usr/local/bin/repo

# Setup new normal user
RUN useradd -ms /bin/bash hendramanu
USER hendramanu
WORKDIR /home/hendramanu

# Setup Git identity
RUN git config --global user.name "Hendra Manudinata"
RUN git config --global user.email "aku.hendramanu@gmail.com"

# Clone compiler
# AOSP Clang 4639204
RUN wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/android-9.0.0_r6/clang-4639204.tar.gz && mkdir ${HOME}/clang-4639204 && tar -zxvf clang-4639204.tar.gz -C ${HOME}/clang-4639204 && rm clang-4639204.tar.gz

# AOSP gcc 4.9
RUN git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 ${HOME}/gcc49-64
RUN git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 ${HOME}/gcc49-32

# Setup environment variables
ENV PATH ${HOME}/clang-4639204/bin:${HOME}/gcc49-64/bin:${HOME}/gcc49-32/bin:$PATH
ENV KBUILD_BUILD_USER hendramanu
ENV KBUILD_BUILD_HOST CirrusCI
