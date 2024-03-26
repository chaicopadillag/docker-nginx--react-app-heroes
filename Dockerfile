FROM node:alpine3.19 as depens
ENV APP=/app
WORKDIR ${APP}
COPY package.json ${APP}
RUN yarn 

FROM node:alpine3.19 as builder
ENV APP=/app
WORKDIR ${APP}
COPY --from=depens ${APP}/node_modules ${APP}/node_modules
COPY . ${APP}
RUN yarn build

FROM nginx:alpine as running
EXPOSE 80
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/ /etc/nginx/conf.d
COPY --from=builder /app/dist /usr/share/nginx/html
COPY assets/ /usr/share/nginx/html/assets
CMD [ "nginx","-g","daemon off;" ]