import { test, expect } from '@playwright/test';

const baseUrl = 'http://localhost:5000';

test.describe('Claims CRUD UI', () => {
  test('View claims list', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await expect(page.locator('h3', { hasText: 'Claims' })).toBeVisible();
    await expect(page.locator('table')).toBeVisible();
  });

  test('Create new claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("New Claim")');
    await expect(page.locator('h3', { hasText: 'New Claim' })).toBeVisible();
    await page.fill('input[aria-label="Claim Number"]', 'CLM-1001');
    await page.fill('input[aria-label="Policy Holder"]', 'John Doe');
    await page.fill('input[aria-label="Date"]', '2024-06-01');
    await page.fill('input[aria-label="Status"]', 'Submitted');
    await page.fill('input[aria-label="Amount"]', '1200');
    await page.click('button:has-text("Save")');
    await expect(page.locator('.modal .modal-title', { hasText: 'Success' })).toBeVisible();
    await page.click('.modal button:has-text("OK")');
    await expect(page.locator('table')).toContainText('CLM-1001');
  });

  test('Edit a claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    // Find the first Edit button and click it
    await page.click('button:has-text("Edit")');
    await expect(page.locator('h3', { hasText: 'Edit Claim' })).toBeVisible();
    await page.fill('input[aria-label="Status"]', 'Reviewed');
    await page.click('button:has-text("Save")');
    await expect(page.locator('.modal .modal-title', { hasText: 'Success' })).toBeVisible();
    await page.click('.modal button:has-text("OK")');
    await expect(page.locator('table')).toContainText('Reviewed');
  });

  test('View claim details', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("View")');
    await expect(page.locator('h3', { hasText: 'Claim Details' })).toBeVisible();
    await expect(page.locator('dt', { hasText: 'Claim Number' })).toBeVisible();
  });

  test('Delete a claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("Delete")');
    await expect(page.locator('.modal .modal-title', { hasText: 'Delete Claim' })).toBeVisible();
    await page.click('.modal button:has-text("Delete")');
    await expect(page.locator('.modal .modal-title', { hasText: 'Delete Claim' })).not.toBeVisible();
  });
});
