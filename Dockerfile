FROM node:18.19.0-alpine3.18

WORKDIR /app

# Example for multiple Base Images
FROM nginx:1.24.0-alpine AS proxy
FROM redis:7.2.3-alpine AS cache

COPY package.json .
RUN npm install

CMD ["npm", "start"]
