import { test, expect } from '@playwright/test';

const baseUrl = 'http://localhost:4200';

test.describe('Angular Claims CRUD UI', () => {
  test('View claims list', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await expect(page.locator('mat-toolbar')).toContainText('Claims');
    await expect(page.locator('table')).toBeVisible();
  });

  test('Create new claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("New Claim")');
    await expect(page.locator('mat-card-title')).toContainText('New Claim');
    await page.fill('input[formcontrolname="claimNumber"]', 'CLM-2001');
    await page.fill('input[formcontrolname="policyHolder"]', 'Jane Smith');
    await page.fill('input[formcontrolname="date"]', '2024-06-01');
    await page.fill('input[formcontrolname="status"]', 'Submitted');
    await page.fill('input[formcontrolname="amount"]', '1500');
    await page.click('button[type="submit"]:has-text("Save")');
    await expect(page).toHaveURL(/\/claims-list$/);
    await expect(page.locator('table')).toContainText('CLM-2001');
  });

  test('Edit a claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("Edit")');
    await expect(page.locator('mat-card-title')).toContainText('Edit Claim');
    await page.fill('input[formcontrolname="status"]', 'Reviewed');
    await page.click('button[type="submit"]:has-text("Save")');
    await expect(page).toHaveURL(/\/claims-list$/);
    await expect(page.locator('table')).toContainText('Reviewed');
  });

  test('View claim details', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("View")');
    await expect(page.locator('mat-card-title')).toContainText('Claim Details');
    await expect(page.locator('dt')).toContainText('Claim Number');
  });

  test('Delete a claim', async ({ page }) => {
    await page.goto(`${baseUrl}/claims`);
    await page.click('button:has-text("Delete")');
    // No modal, so just check the table updates
    await expect(page.locator('table')).not.toContainText('CLM-2001');
  });
});
