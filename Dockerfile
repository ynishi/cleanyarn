FROM fpco/stack-build:lts-14.6 as builder

WORKDIR /usr/lib/gcc/x86_64-linux-gnu/7.4.0
RUN cp crtbeginT.o crtbeginT.o.orig
RUN cp crtbeginS.o crtbeginT.o

ADD . /build
WORKDIR /build

RUN set -e \
  && stack setup \
  && stack --system-ghc build --ghc-options='-fPIC -optl-static -optl-pthread -optc-Os' \
  && stack --local-bin-path /build/bin install

FROM alpine:3.10.2
ENV PATH $PATH:/opt/cleanyarn/bin
ENV VERSION 0.2.3.1_lts-14.6_alpine3.10.2
COPY --from=builder /build/bin/cleanyarn /opt/cleanyarn/bin/cleanyarn
WORKDIR /

ENTRYPOINT ["/opt/cleanyarn/bin/cleanyarn"]
