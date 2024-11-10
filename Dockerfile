FROM node:18.19.0-alpine3.18@sha256:ae124a073f5655a04381a2d95b3c32da4adf5c279f912af432885e7249814156

WORKDIR /app

# Example for multiple Base Images
FROM nginx:1.24.0-alpine@sha256:77e5d4a6ad906c5d3793764085706577fa705b1dc6f244ea0241c4b5e2155385 AS proxy
FROM redis:7.2.3-alpine@sha256:090276da2603db19b154602c374f505d94c10ea57e9749fc3e68e955284bf0fd AS cache
FROM ubuntu:24.04@sha256:ab64a8382e935382638764d8719362bb50ee418d944c1f3d26e0c99fae49a345 AS ubuntu
FROM alpine:3.19.4@sha256:ae65dbf8749a7d4527648ccee1fa3deb6bfcae34cbc30fc67aa45c44dcaa90ee

COPY package.json .
RUN npm install

CMD ["npm", "start"]
