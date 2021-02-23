# Statically compile with optimisations in the build image
FROM ekidd/rust-musl-builder:1.48.0 AS builder
COPY . ./
RUN sudo chown -R rust:rust /home/rust && cargo fetch
RUN cargo build --release

# Copy static binary from build image into minimal Debian-based image
FROM alpine:latest
RUN addgroup -g 1000 -S ocypod && adduser -u 1000 -G ocypod -S ocypod
COPY --chown=ocypod:ocypod --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/ocypod-server \
    /usr/local/bin/
EXPOSE 8023
ENTRYPOINT ["/usr/local/bin/ocypod-server"]
