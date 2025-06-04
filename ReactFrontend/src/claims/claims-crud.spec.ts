import { test, expect } from '@playwright/test';

const baseUrl = 'http://localhost:3000';

test.describe('React Claims CRUD UI', () => {
  test('View claims list', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await expect(page.locator('h6')).toContainText('Claims');
    await expect(page.locator('table')).toBeVisible();
  });

  test('Create new claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("New Claim")');
    await expect(page.locator('h6')).toContainText('New Claim');
    await page.fill('input[name="claimNumber"]', 'CLM-3001');
    await page.fill('input[name="policyHolder"]', 'Alex Johnson');
    await page.fill('input[name="date"]', '2024-06-01');
    await page.fill('input[name="status"]', 'Submitted');
    await page.fill('input[name="amount"]', '2000');
    await page.click('button[type="submit"]:has-text("Save")');
    await expect(page).toHaveURL(/\/claims$/);
    await expect(page.locator('table')).toContainText('CLM-3001');
  });

  test('Edit a claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("Edit")');
    await expect(page.locator('h6')).toContainText('Edit Claim');
    await page.fill('input[name="status"]', 'Reviewed');
    await page.click('button[type="submit"]:has-text("Save")');
    await expect(page).toHaveURL(/\/claims$/);
    await expect(page.locator('table')).toContainText('Reviewed');
  });

  test('View claim details', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("View")');
    await expect(page.locator('h6')).toContainText('Claim Details');
    await expect(page.locator('strong')).toContainText('Claim Number');
  });

  test('Delete a claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("Delete")');
    // No modal, so just check the table updates
    await expect(page.locator('table')).not.toContainText('CLM-3001');
  });
});
