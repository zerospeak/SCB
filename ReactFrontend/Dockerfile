# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY ReactFrontend/package.json ./
RUN npm install
COPY ReactFrontend/. ./
RUN ls -l /app/src || true
RUN ls -l /app/src/claims || true
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY ReactFrontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
