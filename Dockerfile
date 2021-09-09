FROM node:16-alpine

RUN npm i -g standard-version

COPY ./run.sh /run.sh

ENTRYPOINT bash /run.sh