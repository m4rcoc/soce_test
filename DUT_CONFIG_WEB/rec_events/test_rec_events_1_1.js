// Generated by Selenium IDE
const { Builder, By, Key, until } = require('selenium-webdriver');
const assert = require('assert');

'use strict';

let jsonData = require('../constants.json');

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

(async function example() {

  var webVersion = "new"
  let driver = await new Builder().forBrowser('firefox').build();
  try {
    await driver.get("http://"+jsonData.user_admin+":"+jsonData.pass_admin+"@"+jsonData.ip+"/")
   
      

} finally {
    await driver.quit();
  }
})();