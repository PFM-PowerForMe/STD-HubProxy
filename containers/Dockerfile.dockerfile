FROM docker.io/library/node:lts AS frontend
WORKDIR /web
COPY source-src/web/package.json source-src/web/package-lock.json ./
RUN npm ci
COPY source-src/web/ .
RUN npm run build



# 构建时
FROM docker.io/library/golang:alpine AS builder
ARG REPO
# eg. amd64 | arm64
ARG ARCH
# eg. x86_64 | aarch64
ARG CPU_ARCH
ARG TAG
# eg. latest
ARG IMAGE_VERSION
ENV REPO=$REPO \
     ARCH=$ARCH \
     CPU_ARCH=$CPU_ARCH \
     TAG=$TAG \
     IMAGE_VERSION=$IMAGE_VERSION

RUN apk add --no-cache --virtual .build-deps \
                upx

ENV CGO_ENABLED=0 \
     GOOS=linux \
     GOARCH=$ARCH

WORKDIR /output/
WORKDIR /source/
COPY source-src/ .
WORKDIR /source/src
COPY --from=frontend /src/dist ./dist
RUN go mod download
RUN go build -o /output/hubproxy -trimpath -ldflags="-w -s -X main.Version=${TAG}" .
RUN upx -9 /output/hubproxy


FROM ghcr.io/pfm-powerforme/base-nginx:latest AS nginx
FROM ghcr.io/pfm-powerforme/base-wireproxy:latest AS wireproxy


# 运行时
FROM ghcr.io/pfm-powerforme/s6-box:latest AS runtime
ENV SERVER_HOST=127.0.0.1 \
     SERVER_PORT=8000
COPY --from=nginx / /
COPY --from=wireproxy / /
COPY --from=builder /output/hubproxy /opt/hubproxy/hubproxy
COPY --from=builder /source/src/config.toml /opt/hubproxy/config.toml
COPY rootfs/ /
RUN chown www-data:www-data -R /opt/hubproxy/
RUN /pfm/bin/fix_env
WORKDIR /opt/
EXPOSE 8080

