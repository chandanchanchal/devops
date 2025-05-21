FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y stress-ng && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["stress-ng", "--help"]
