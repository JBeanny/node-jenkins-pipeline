FROM node:16-alpine
WORKDIR /usr/src/app
RUN npm config set registry https://registry.npmjs.org/
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8081
CMD ["node","./src/server.js"]

# to run docker

# docker run --env-file .env  -p 4000:4000 -d sabaicode/camformant:1.0