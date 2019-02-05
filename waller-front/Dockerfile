FROM node:11.9.0-alpine

RUN apk update
RUN apk add build-base jpeg-dev zlib-dev zlib

RUN mkdir -p /app/waller-front
COPY . /app/waller-front
WORKDIR /app/waller-front

RUN yarn
RUN yarn build
RUN yarn global add serve

CMD ["serve", "-s", "build"]
