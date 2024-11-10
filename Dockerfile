FROM node:18.19.0-alpine3.18

WORKDIR /app

# Example for multiple Base Images
FROM nginx:1.27.2-alpine@sha256:2140dad235c130ac861018a4e13a6bc8aea3a35f3a40e20c1b060d51a7efd250 AS proxy
FROM redis:7.2.3-alpine AS cache
FROM ubuntu:24.04@sha256:ab64a8382e935382638764d8719362bb50ee418d944c1f3d26e0c99fae49a345 AS ubuntu
FROM alpine:3.19.4@sha256:ae65dbf8749a7d4527648ccee1fa3deb6bfcae34cbc30fc67aa45c44dcaa90ee

COPY package.json .
RUN npm install

CMD ["npm", "start"]
