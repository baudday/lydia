FROM node:20-slim
WORKDIR /app

RUN apt-get update

COPY ./gateway/package*.json .
RUN npm install

COPY ./lydia_client/build/web /app/public

COPY . .

CMD [ "npm", "start" ]