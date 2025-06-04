# Test info

- Name: Claims CRUD UI >> View claims list
- Location: C:\temp\BCS\Frontend\Tests\ClaimsCrud.spec.ts:6:7

# Error details

```
Error: Timed out 5000ms waiting for expect(locator).toBeVisible()

Locator: locator('h3').filter({ hasText: 'Claims' })
Expected: visible
Received: <element(s) not found>
Call log:
  - expect.toBeVisible with timeout 5000ms
  - waiting for locator('h3').filter({ hasText: 'Claims' })

    at C:\temp\BCS\Frontend\Tests\ClaimsCrud.spec.ts:8:61
```

# Test source

```ts
   1 | import { test, expect } from '@playwright/test';
   2 |
   3 | const baseUrl = 'http://localhost:5000';
   4 |
   5 | test.describe('Claims CRUD UI', () => {
   6 |   test('View claims list', async ({ page }) => {
   7 |     await page.goto(`${baseUrl}/claims-list`);
>  8 |     await expect(page.locator('h3', { hasText: 'Claims' })).toBeVisible();
     |                                                             ^ Error: Timed out 5000ms waiting for expect(locator).toBeVisible()
   9 |     await expect(page.locator('table')).toBeVisible();
  10 |   });
  11 |
  12 |   test('Create new claim', async ({ page }) => {
  13 |     await page.goto(`${baseUrl}/claims`);
  14 |     await page.click('button:has-text("New Claim")');
  15 |     await expect(page.locator('h3', { hasText: 'New Claim' })).toBeVisible();
  16 |     await page.fill('input[aria-label="Claim Number"]', 'CLM-1001');
  17 |     await page.fill('input[aria-label="Policy Holder"]', 'John Doe');
  18 |     await page.fill('input[aria-label="Date"]', '2024-06-01');
  19 |     await page.fill('input[aria-label="Status"]', 'Submitted');
  20 |     await page.fill('input[aria-label="Amount"]', '1200');
  21 |     await page.click('button:has-text("Save")');
  22 |     await expect(page.locator('.modal .modal-title', { hasText: 'Success' })).toBeVisible();
  23 |     await page.click('.modal button:has-text("OK")');
  24 |     await expect(page.locator('table')).toContainText('CLM-1001');
  25 |   });
  26 |
  27 |   test('Edit a claim', async ({ page }) => {
  28 |     await page.goto(`${baseUrl}/claims`);
  29 |     // Find the first Edit button and click it
  30 |     await page.click('button:has-text("Edit")');
  31 |     await expect(page.locator('h3', { hasText: 'Edit Claim' })).toBeVisible();
  32 |     await page.fill('input[aria-label="Status"]', 'Reviewed');
  33 |     await page.click('button:has-text("Save")');
  34 |     await expect(page.locator('.modal .modal-title', { hasText: 'Success' })).toBeVisible();
  35 |     await page.click('.modal button:has-text("OK")');
  36 |     await expect(page.locator('table')).toContainText('Reviewed');
  37 |   });
  38 |
  39 |   test('View claim details', async ({ page }) => {
  40 |     await page.goto(`${baseUrl}/claims`);
  41 |     await page.click('button:has-text("View")');
  42 |     await expect(page.locator('h3', { hasText: 'Claim Details' })).toBeVisible();
  43 |     await expect(page.locator('dt', { hasText: 'Claim Number' })).toBeVisible();
  44 |   });
  45 |
  46 |   test('Delete a claim', async ({ page }) => {
  47 |     await page.goto(`${baseUrl}/claims`);
  48 |     await page.click('button:has-text("Delete")');
  49 |     await expect(page.locator('.modal .modal-title', { hasText: 'Delete Claim' })).toBeVisible();
  50 |     await page.click('.modal button:has-text("Delete")');
  51 |     await expect(page.locator('.modal .modal-title', { hasText: 'Delete Claim' })).not.toBeVisible();
  52 |   });
  53 | });
  54 |
```