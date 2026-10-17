const { chromium } = require(process.env.PLAYWRIGHT_MODULE);
const fs = require('fs');

async function main() {
  const [mode, specFile] = process.argv.slice(2);
  const specs = JSON.parse(fs.readFileSync(specFile, 'utf8'));
  const browser = await chromium.launch({ headless: true, args: ['--disable-gpu'] });
  try {
    for (const spec of specs) {
      const page = await browser.newPage({
        viewport: { width: spec.width || 1200, height: spec.height || 800 },
        deviceScaleFactor: spec.scale || 2,
      });
      try {
        await page.goto(spec.url, { waitUntil: 'domcontentloaded', timeout: 30000 });
        if (mode === 'cards') {
          await page.locator('#card').screenshot({ path: spec.out, animations: 'disabled' });
        } else {
          await page.waitForTimeout(spec.wait_ms);
          await page.screenshot({ path: spec.out, animations: 'disabled' });
        }
        console.log(`${mode}: ${spec.out}`);
      } finally {
        await page.close();
      }
    }
  } finally {
    await browser.close();
  }
}

main().catch(error => { console.error(error); process.exit(1); });
