FROM node:22.2.0-alpine3.18@sha256:a46d9fcb38cae53de45b35b90f6df232342242bebc9323a417416eb67942979e

WORKDIR /app

# Example for multiple Base Images
FROM nginx:1.27.2-alpine@sha256:2140dad235c130ac861018a4e13a6bc8aea3a35f3a40e20c1b060d51a7efd250 AS proxy
FROM redis:7.4.1-alpine@sha256:de13e74e14b98eb96bdf886791ae47686c3c5d29f9d5f85ea55206843e3fce26 AS cache
FROM ubuntu:24.04@sha256:ab64a8382e935382638764d8719362bb50ee418d944c1f3d26e0c99fae49a345 AS ubuntu
FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d

COPY package.json .
RUN npm install

CMD ["npm", "start"]
