FROM alpine:3.6

# 配置环境变量
ENV NODE_VERSION=8.4.0 NPM_VERSION=5.3.0 YARN_VERSION=latest
# 添加node用户
RUN adduser -D -u 1000 node \
  # 安装编译依赖包
  && apk update \
  && apk upgrade \
  && apk add --no-cache \
  libstdc++ \
  python \
  && apk add --no-cache --virtual .build-deps \
  binutils-gold \
  curl \
  g++ \
  gcc \
  gnupg \
  libgcc \
  linux-headers \
  make \
  # 下载和配置Node.js环境
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done \
  && curl -sfSLO https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz && \
  curl -sfSL https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc | gpg --batch --decrypt | \
  grep " node-v$NODE_VERSION.tar.xz\$" | sha256sum -c | grep ': OK$' \
  && tar -xf "node-v$NODE_VERSION.tar.xz" \
  && cd "node-v$NODE_VERSION" \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  # 删除无用的包
  && apk del .build-deps \
  && cd .. \
  && rm -Rf "node-v$NODE_VERSION" \
  && rm "node-v$NODE_VERSION.tar.xz" \
  # 安装yarn latest, alpine3.6+
  # && npm i -g yarn \
  # 安装 pm2(Advanced, production process manager for Node.js)
  # && yarn global add pm2
  && npm i -g pm2 yarn


