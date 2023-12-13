FROM node:20-slim
WORKDIR /app

RUN apt-get update

COPY ./package*.json .
RUN npm install

COPY . .

CMD [ "npm", "start" ]