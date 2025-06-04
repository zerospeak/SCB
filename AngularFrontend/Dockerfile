# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install -g @angular/cli@latest && npm install
COPY . .
RUN ng build --configuration=production

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist/angular-frontend /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
