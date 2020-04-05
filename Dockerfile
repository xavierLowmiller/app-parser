FROM swift:5.1.5 as builder

RUN apt-get -qq update && apt-get install -y \
  libssl-dev zlib1g-dev \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

# # Production image
# FROM ubuntu:18.04

# RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get install -y \ 
#   libatomic1 libicu60 libxml2 libcurl4 libz-dev libbsd0 tzdata \
#   && rm -r /var/lib/apt/lists/*
# WORKDIR /app
# COPY --from=builder /build/bin/app-parser .
# COPY --from=builder /build/lib/* /usr/lib/

# ENTRYPOINT /bin/bash
