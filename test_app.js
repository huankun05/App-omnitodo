const { chromium } = require('playwright');

async function runTests() {
  const browser = await chromium.launch({ 
    headless: true,
    args: ['--disable-gpu', '--no-sandbox']
  });
  const context = await browser.newContext({ viewport: { width: 1280, height: 720 } });
  const page = await context.newPage();

  // 启用详细日志
  page.on('console', msg => {
    if (msg.type() === 'error') {
      console.log('Browser Console [ERROR]:', msg.text().substring(0, 300));
    }
  });

  try {
    // ========== Test 1: 访问首页 ==========
    console.log('\n========================================');
    console.log('Test 1: 访问 OmniTodo 首页');
    console.log('========================================');
    await page.goto('http://localhost:8080');
    
    // 等待 Flutter 加载
    await page.waitForTimeout(5000);

    const title = await page.title();
    console.log('Page title:', title);

    // 检查 Flutter 元素
    const flutterElement = await page.$('flt-glass-pane');
    console.log('Flutter glass pane found:', !!flutterElement);

    // 截图
    await page.screenshot({ path: 'test_screenshots/01_home.png', fullPage: true });
    console.log('Screenshot: 01_home.png');

    // ========== Test 2: 检查页面内容 ==========
    console.log('\n========================================');
    console.log('Test 2: 检查页面内容');
    console.log('========================================');

    // 获取 body 内所有文本
    const bodyHTML = await page.evaluate(() => document.body.innerHTML.substring(0, 3000));
    console.log('Body HTML preview:', bodyHTML.substring(0, 1000));

    // ========== Test 3: 尝试直接使用 JavaScript 操作 Flutter ==========
    console.log('\n========================================');
    console.log('Test 3: 尝试键盘输入测试');
    console.log('========================================');

    // 直接点击页面中心位置（通常是登录表单区域）
    await page.mouse.click(640, 360); // 页面中心
    await page.waitForTimeout(1000);
    
    // 尝试输入邮箱
    await page.keyboard.type('test@test.com');
    await page.waitForTimeout(1000);
    
    await page.screenshot({ path: 'test_screenshots/02_after_input.png', fullPage: true });
    console.log('Screenshot: 02_after_input.png');

    // Tab 到密码
    await page.keyboard.press('Tab');
    await page.waitForTimeout(500);
    await page.keyboard.type('200513');
    await page.waitForTimeout(1000);
    
    await page.screenshot({ path: 'test_screenshots/03_password_entered.png', fullPage: true });

    // Enter 登录
    await page.keyboard.press('Enter');
    await page.waitForTimeout(5000);
    
    await page.screenshot({ path: 'test_screenshots/04_after_login.png', fullPage: true });
    console.log('Screenshot: 04_after_login.png');
    console.log('Current URL:', page.url());

    // ========== Test 4: 检查登录后的内容 ==========
    console.log('\n========================================');
    console.log('Test 4: 检查登录后的页面');
    console.log('========================================');

    const afterLoginHTML = await page.evaluate(() => document.body.innerHTML.substring(0, 2000));
    console.log('After login HTML preview:', afterLoginHTML.substring(0, 800));

    // ========== Test 5: 导航到不同页面 ==========
    console.log('\n========================================');
    console.log('Test 5: 导航测试');
    console.log('========================================');

    // 测试各个路由
    const routes = [
      { path: '/', name: 'home' },
      { path: '/#/home', name: 'home' },
      { path: '/#/login', name: 'login' },
      { path: '/#/register', name: 'register' },
      { path: '/#/focus', name: 'focus' },
      { path: '/#/calendar', name: 'calendar' },
      { path: '/#/settings', name: 'settings' },
    ];

    for (const route of routes) {
      console.log(`\nNavigating to ${route.name}...`);
      await page.goto(`http://localhost:8080${route.path}`);
      await page.waitForTimeout(3000);
      await page.screenshot({ path: `test_screenshots/05_${route.name}.png`, fullPage: true });
      console.log(`Screenshot: 05_${route.name}.png`);
    }

    // ========== 完成 ==========
    console.log('\n========================================');
    console.log('所有测试完成！');
    console.log('========================================');
    console.log('\n生成截图列表:');
    console.log('  01_home.png - 首页');
    console.log('  02_after_input.png - 输入邮箱后');
    console.log('  03_password_entered.png - 输入密码后');
    console.log('  04_after_login.png - 登录后');
    console.log('  05_*.png - 各页面截图');

  } catch (error) {
    console.error('Test error:', error.message);
    console.error(error.stack);
    await page.screenshot({ path: 'test_screenshots/error_state.png', fullPage: true });
  } finally {
    await browser.close();
  }
}

runTests().catch(console.error);
