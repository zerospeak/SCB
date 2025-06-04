# Use nginx to serve Blazor WebAssembly static files
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Frontend.csproj", "./"]
RUN dotnet --info
RUN dotnet restore "Frontend.csproj"
COPY . .
RUN dotnet publish "Frontend.csproj" -c Release -o /app/publish
RUN ls -l /app/publish || true

FROM nginx:alpine AS final
# Output the contents of the publish directory for debugging
RUN ls -l /app/publish || true
COPY --from=build /app/publish/wwwroot/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN ls -l /usr/share/nginx/html || true
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
