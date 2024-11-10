FROM node:18.19.0-alpine3.18

WORKDIR /app

# Example for multiple Base Images
FROM nginx:1.24.0-alpine AS proxy
FROM redis:7.2.3-alpine AS cache
FROM ubuntu:24.04@sha256:ab64a8382e935382638764d8719362bb50ee418d944c1f3d26e0c99fae49a345 AS ubuntu
FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d

COPY package.json .
RUN npm install

CMD ["npm", "start"]
