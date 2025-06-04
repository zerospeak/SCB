# Test info

- Name: Angular Claims CRUD UI >> View claims list
- Location: C:\temp\BCS\AngularFrontend\src\app\claims\claims-crud.spec.ts:6:7

# Error details

```
Error: page.goto: net::ERR_CONNECTION_REFUSED at http://localhost:4200/claims
Call log:
  - navigating to "http://localhost:4200/claims", waiting until "load"

    at C:\temp\BCS\AngularFrontend\src\app\claims\claims-crud.spec.ts:7:16
```

# Test source

```ts
   1 | import { test, expect } from '@playwright/test';
   2 |
   3 | const baseUrl = 'http://localhost:4200';
   4 |
   5 | test.describe('Angular Claims CRUD UI', () => {
   6 |   test('View claims list', async ({ page }) => {
>  7 |     await page.goto(`${baseUrl}/claims`);
     |                ^ Error: page.goto: net::ERR_CONNECTION_REFUSED at http://localhost:4200/claims
   8 |     await expect(page.locator('mat-toolbar')).toContainText('Claims');
   9 |     await expect(page.locator('table')).toBeVisible();
  10 |   });
  11 |
  12 |   test('Create new claim', async ({ page }) => {
  13 |     await page.goto(`${baseUrl}/claims`);
  14 |     await page.click('button:has-text("New Claim")');
  15 |     await expect(page.locator('mat-card-title')).toContainText('New Claim');
  16 |     await page.fill('input[formcontrolname="claimNumber"]', 'CLM-2001');
  17 |     await page.fill('input[formcontrolname="policyHolder"]', 'Jane Smith');
  18 |     await page.fill('input[formcontrolname="date"]', '2024-06-01');
  19 |     await page.fill('input[formcontrolname="status"]', 'Submitted');
  20 |     await page.fill('input[formcontrolname="amount"]', '1500');
  21 |     await page.click('button[type="submit"]:has-text("Save")');
  22 |     await expect(page).toHaveURL(/\/claims$/);
  23 |     await expect(page.locator('table')).toContainText('CLM-2001');
  24 |   });
  25 |
  26 |   test('Edit a claim', async ({ page }) => {
  27 |     await page.goto(`${baseUrl}/claims`);
  28 |     await page.click('button:has-text("Edit")');
  29 |     await expect(page.locator('mat-card-title')).toContainText('Edit Claim');
  30 |     await page.fill('input[formcontrolname="status"]', 'Reviewed');
  31 |     await page.click('button[type="submit"]:has-text("Save")');
  32 |     await expect(page).toHaveURL(/\/claims$/);
  33 |     await expect(page.locator('table')).toContainText('Reviewed');
  34 |   });
  35 |
  36 |   test('View claim details', async ({ page }) => {
  37 |     await page.goto(`${baseUrl}/claims`);
  38 |     await page.click('button:has-text("View")');
  39 |     await expect(page.locator('mat-card-title')).toContainText('Claim Details');
  40 |     await expect(page.locator('dt')).toContainText('Claim Number');
  41 |   });
  42 |
  43 |   test('Delete a claim', async ({ page }) => {
  44 |     await page.goto(`${baseUrl}/claims`);
  45 |     await page.click('button:has-text("Delete")');
  46 |     // No modal, so just check the table updates
  47 |     await expect(page.locator('table')).not.toContainText('CLM-2001');
  48 |   });
  49 | });
  50 |
```