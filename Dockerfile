FROM alpine:3.7

# 配置环境变量
ENV NODE_VERSION=8.4.0 YARN_VERSION=latest 
ENV CONFIG_FLAGS="--fully-static" DEL_PKGS="libstdc++" RM_DIRS=/usr/include
# 添加node用户
RUN adduser -D -u 1000 node \
  # 安装编译依赖包
  && apk update \
  && apk upgrade \
  && apk add --no-cache nodejs nodejs-npm yarn\
  && npm i -g pm2
  


