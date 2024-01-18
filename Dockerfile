FROM node:20-slim
WORKDIR /app

RUN apt-get update

COPY ./package*.json ./

RUN npm install

COPY ./ /app/

COPY ./lydia_client/build/web/ /app/gateway/public/

CMD [ "npm", "start" ]