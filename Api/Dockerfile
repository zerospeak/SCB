# DEV/DEMO ONLY: .NET 8 runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Api.csproj", "./"]
RUN dotnet restore "./Api.csproj"
COPY . .
RUN dotnet build "Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# For demo/dev only: no production-only settings
ENTRYPOINT ["dotnet", "Api.dll"]
# Uncomment and configure for production
# ENV ASPNETCORE_ENVIRONMENT=Production
