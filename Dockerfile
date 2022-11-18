ARG GRAMINE_VERSION=1.3.1


FROM rust:1.65.0-bullseye AS app

WORKDIR /output

WORKDIR /project

ADD app .

RUN cargo build --release

RUN cp target/release/app /output/

FROM sammyne/gramine:${GRAMINE_VERSION}-ubuntu20.04 AS builder

RUN developer_key_path=~/.gramine/developer-key.pem &&\
  mkdir -p $(dirname $developer_key_path)           &&\
  openssl genrsa -3 -out $developer_key_path 3072

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

WORKDIR /output

ADD gramine .

COPY --from=app /output/app app

RUN make SGX=1 DEBUG=1


FROM sammyne/sgx-dcap:2.17.100.3-dcap1.14.100.3-ubuntu20.04

RUN apt update && apt install -y libprotobuf-c-dev

WORKDIR /app

COPY --from=builder /usr/local/bin/gramine-sgx /usr/local/bin/gramine-sgx
COPY --from=builder /usr/local/lib/x86_64-linux-gnu/gramine /usr/local/lib/x86_64-linux-gnu/gramine

COPY --from=builder /output .

CMD ["gramine-sgx", "app"]
