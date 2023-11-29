# Start with a rust alpine image
FROM rust:1-alpine3.17 as builder

ENV APPNAME=otee-opcua
ENV OPCUA_PORT=4855
ENV RUST_BACKTRACE=1

# This is important, see https://github.com/rust-lang/docker-rust/issues/85
ENV RUSTFLAGS="-C target-feature=-crt-static"
# if needed, add additional dependencies here
RUN apk add --no-cache musl-dev openssl pkgconfig openssl-dev

# set the workdir and copy the source into it
WORKDIR /app
COPY ./ /app
# do a release build
RUN cargo build --release
RUN strip target/release/${APPNAME}

# use a plain alpine image, the alpine version needs to match the builder
FROM alpine:3.17
# if needed, install additional dependencies here
RUN apk add --no-cache libgcc openssl
# copy the binary into the final image
COPY ./server.conf /app/
COPY --from=builder /app/target/release/otee-opcua /app

# Expose OPC-UA port
EXPOSE ${OPCUA_PORT}

# set the binary as entrypoint
CMD ["/app/otee-opcua"]