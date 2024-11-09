FROM node:18.19.0-alpine3.18

WORKDIR /app

# Example for multiple Base Images
FROM nginx:1.24.0-alpine AS proxy
FROM redis:7.2.3-alpine AS cache
FROM ubuntu:24.04@sha256:ab64a8382e935382638764d8719362bb50ee418d944c1f3d26e0c99fae49a345 AS ubuntu
FROM alpine:3.19.4@sha256:ae65dbf8749a7d4527648ccee1fa3deb6bfcae34cbc30fc67aa45c44dcaa90ee

COPY package.json .
RUN npm install

CMD ["npm", "start"]
