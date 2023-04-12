FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY package-retention package-retention
USER 65532:65532

ENTRYPOINT ["/package-retention"]
