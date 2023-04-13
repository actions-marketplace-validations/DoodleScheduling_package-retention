FROM gcr.io/distroless/static:latest
WORKDIR /
COPY package-retention package-retention

ENTRYPOINT ["/package-retention"]
