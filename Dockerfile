FROM hub.docker.zlabi.dev/jenkins/agent:3283.v92c105e0f819-1-alpine-jdk21

USER root

RUN apk update

RUN apk add --no-cache docker-cli
RUN apk add --no-cache docker-cli-compose

ENV PYTHONUNBUFFERED=1
RUN apk add --no-cache python3 pipx

# Install Node.js 20.19.5 + npm 10.8.2
ENV NODE_VERSION=20.19.5
RUN apk add --no-cache curl tar xz \
 && curl -fsSL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz \
    -o /tmp/node.tar.xz \
 && mkdir -p /usr/local/lib/nodejs \
 && tar -xJf /tmp/node.tar.xz -C /usr/local/lib/nodejs \
 && ln -sf /usr/local/lib/nodejs/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/node \
 && ln -sf /usr/local/lib/nodejs/node-v$NODE_VERSION-linux-x64/bin/npm  /usr/local/bin/npm \
 && ln -sf /usr/local/lib/nodejs/node-v$NODE_VERSION-linux-x64/bin/npx  /usr/local/bin/npx \
 && rm /tmp/node.tar.xz

RUN mkdir -p /home/jenkins/tmp && chmod 777 /home/jenkins/tmp

USER jenkins
ENV TMPDIR=/home/jenkins/tmp

CMD ["/bin/sh"]
