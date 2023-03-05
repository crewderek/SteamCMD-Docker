# Use the latest Ubuntu LTS as the base image
FROM ubuntu:20.04

# Set environment variables for SteamCMD
ENV STEAMCMD_DIR=/home/steam/steamcmd \
    STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    STEAM_USER=steam \
    STEAM_UID=1000 \
    STEAM_GID=1000

# Install dependencies for SteamCMD
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
		nano \
        ca-certificates \
        lib32gcc1 \
        lib32stdc++6 \
        libcurl4-gnutls-dev:i386 \
        wget \
        && rm -rf /var/lib/apt/lists/*

# Create a steam user with home directory
RUN useradd -m -u $STEAM_UID -U -G tty -s /bin/bash $STEAM_USER && \
    mkdir -p $STEAMCMD_DIR && \
    chown -R $STEAM_USER:$STEAM_USER $STEAMCMD_DIR

# Download and extract SteamCMD
RUN cd /tmp && \
    wget -qO- $STEAMCMD_URL | tar -zxvf - -C $STEAMCMD_DIR && \
    chown -R $STEAM_USER:$STEAM_USER $STEAMCMD_DIR

# Switch to the steam user
USER $STEAM_USER

# Set the working directory to the SteamCMD directory
WORKDIR $STEAMCMD_DIR

# Expose the default SteamCMD port
EXPOSE 27015/tcp

# Set the entrypoint to SteamCMD
ENTRYPOINT ["./steamcmd.sh"]