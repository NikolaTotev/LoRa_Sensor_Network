FROM node:12.18.3

RUN mkdir /app
WORKDIR /app
COPY . .

RUN npm install

EXPOSE 3000

CMD [ "npm", "start" ]