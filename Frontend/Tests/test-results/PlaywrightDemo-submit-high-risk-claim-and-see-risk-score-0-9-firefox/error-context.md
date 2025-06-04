# Test info

- Name: submit high risk claim and see risk score 0.9
- Location: C:\temp\BCS\Frontend\Tests\PlaywrightDemo.spec.ts:14:5

# Error details

```
TimeoutError: locator.waitFor: Timeout 30000ms exceeded.
Call log:
  - waiting for locator('input[type="text"]').first() to be visible

    at C:\temp\BCS\Frontend\Tests\PlaywrightDemo.spec.ts:17:27
```

# Test source

```ts
   1 | import { test, expect } from '@playwright/test';
   2 |
   3 | test('submit low risk claim and see risk score 0.1', async ({ page }) => {
   4 |   await page.goto('/submit-claim');
   5 |   const textInputs = page.locator('input[type="text"]');
   6 |   await textInputs.nth(0).waitFor({ state: 'visible', timeout: 30000 });
   7 |   await textInputs.nth(0).fill('P100'); // Provider ID
   8 |   await textInputs.nth(1).fill('123-45-6789'); // Member SSN
   9 |   await page.locator('input[type="number"]').fill('500'); // Paid Amount
  10 |   await page.click('button[type="submit"]');
  11 |   await expect(page.locator('text=Risk Score: 0.1')).toBeVisible();
  12 | });
  13 |
  14 | test('submit high risk claim and see risk score 0.9', async ({ page }) => {
  15 |   await page.goto('/submit-claim');
  16 |   const textInputs = page.locator('input[type="text"]');
> 17 |   await textInputs.nth(0).waitFor({ state: 'visible', timeout: 30000 });
     |                           ^ TimeoutError: locator.waitFor: Timeout 30000ms exceeded.
  18 |   await textInputs.nth(0).fill('P200'); // Provider ID
  19 |   await textInputs.nth(1).fill('987-65-4321'); // Member SSN
  20 |   await page.locator('input[type="number"]').fill('10000'); // Paid Amount
  21 |   await page.click('button[type="submit"]');
  22 |   await expect(page.locator('text=Risk Score: 0.9')).toBeVisible();
  23 | });
  24 |
```