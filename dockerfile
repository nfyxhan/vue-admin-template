FROM registry.nfyxhan.com:5000/nfyxhan/node:builder as builder
WORKDIR /home/node
ADD package.json .
RUN npm install --registry=https://registry.npm.taobao.org
ADD . .
RUN npm run lint-fix && npm run build:prod

# build with https://github.com/Ironclad/docker-nginx-headers-more.git but change nginx version to 17.4
FROM nginx:1.17-alpine 
COPY --from=builder /home/node/dist /usr/share/nginx/html
ADD ./start.sh ./start.sh
ADD ./nginx.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT ["./start.sh"]

