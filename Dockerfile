FROM swift:5.1.5 as builder

RUN apt-get -qq update && apt-get install -y \
  libssl-dev zlib1g-dev unzip \
  && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN swift test
