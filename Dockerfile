FROM debian:bookworm

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV LC_ALL=C
ENV LANGUAGE=C
ENV LANG=C

# Install dependencies required for building
RUN apt-get update && apt-get install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    syslinux-utils \
    isolinux \
    sudo \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for building
RUN useradd -m -s /bin/bash -G sudo builder && \
    echo 'builder ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/builder && \
    chmod 440 /etc/sudoers.d/builder

# Set working directory
WORKDIR /workspace

# Copy build scripts and configuration
COPY --chown=builder:builder . /workspace/

# Make scripts executable
RUN chmod +x /workspace/build_gooner.sh

# Switch to builder user
USER builder

# Set the default command
CMD ["./docker-build.sh"]