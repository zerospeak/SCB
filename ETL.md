# ETL Service Documentation

**Last Updated: 2024-06-03**

> This documentation reflects the current state of the application, scripts, and architecture as of the above date.

## Application Current State (as of latest update)
- **Status:** Running in Docker as a PowerShell container
- **Script:** Runs `etl.ps1` and stays alive for dev/demo
- **Build/Run:** Included in run-dev.ps1; auto-built and started
- **Common Issue:** If container exits, ensure `etl.ps1` contains a wait loop (already auto-fixed)

## Overview
The ETL (Extract, Transform, Load) service is responsible for batch processing, importing, and transforming insurance claims data. It is currently a PowerShell script stub for future extension.

## Extending
- Add logic to extract data from external sources (CSV, APIs, etc.).
- Transform and clean data as needed for analytics and compliance.
- Load processed data into the SQL Server database.
- Schedule ETL jobs or trigger them via API/webhooks.
