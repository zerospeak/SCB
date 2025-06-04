# DEV/DEMO ONLY: PowerShell ETL stub
FROM mcr.microsoft.com/powershell:lts
WORKDIR /app
COPY etl.ps1 .
# For demo/dev only: no production ETL logic
CMD ["pwsh", "-File", "etl.ps1"]
# Uncomment and configure for production
# CMD ["pwsh", "-File", "etl-prod.ps1"]
