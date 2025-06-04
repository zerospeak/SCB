import { test, expect } from '@playwright/test';

test('submit low risk claim and see risk score 0.1', async ({ page }) => {
  await page.goto('/submit-claim');
  const textInputs = page.locator('input[type="text"]');
  await textInputs.nth(0).waitFor({ state: 'visible', timeout: 30000 });
  await textInputs.nth(0).fill('P100'); // Provider ID
  await textInputs.nth(1).fill('123-45-6789'); // Member SSN
  await page.locator('input[type="number"]').fill('500'); // Paid Amount
  await page.click('button[type="submit"]');
  await expect(page.locator('text=Risk Score: 0.1')).toBeVisible();
});

test('submit high risk claim and see risk score 0.9', async ({ page }) => {
  await page.goto('/submit-claim');
  const textInputs = page.locator('input[type="text"]');
  await textInputs.nth(0).waitFor({ state: 'visible', timeout: 30000 });
  await textInputs.nth(0).fill('P200'); // Provider ID
  await textInputs.nth(1).fill('987-65-4321'); // Member SSN
  await page.locator('input[type="number"]').fill('10000'); // Paid Amount
  await page.click('button[type="submit"]');
  await expect(page.locator('text=Risk Score: 0.9')).toBeVisible();
});
