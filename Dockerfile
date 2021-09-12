FROM node:16-alpine

RUN apk --no-cache add bash
RUN npm i -g standard-version

COPY ./run.sh /run.sh

ENTRYPOINT bash /run.sh