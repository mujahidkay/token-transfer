FROM debian:bullseye

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and set up the relayer
RUN curl -L https://storage.googleapis.com/simulationlab_cloudbuild/rly --output "/bin/relayer" && \
    chmod +x /bin/relayer

# Copy configuration files
COPY internal-chain-config.json external-chain-config.json /root/.relayer/config/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Default command to keep container running
CMD ["tail", "-f", "/dev/null"]
