// Generated by Selenium IDE
const { Builder, By, Key, until } = require('selenium-webdriver');
const assert = require('assert');

'use strict';
fs = require('fs');

let jsonData = require('../constants.json');
const { syncBuiltinESMExports } = require('module');

console.log(jsonData);

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function writeScreenshot(data, name) {
  name = name || 'ss.png';
  var screenshotPath = '';
  fs.writeFileSync(screenshotPath + name, data, 'base64');
};

//await (await driver.wait(until.elementLocated(By.id("tr_rg")),2000)).click()

(async function example() {

  var webVersion = "new"

  let driver = await new Builder().forBrowser('firefox').build();
  try {
		
    await driver.get("http://"+jsonData.user_basic+":"+jsonData.pass_basic+"@"+jsonData.ip+"/")
    //await driver.get("http://192.168.137.14/")
    
    await driver.manage().window().setRect(1918, 921)

    await (await driver.wait(until.elementLocated(By.css(".gear-right > a")),4000)).click()

    if (webVersion=="new"){
      await (await driver.wait(until.elementLocated(By.xpath("//span[.='System']")),4000)).click()       
    } else {
      await (await driver.wait(until.elementLocated(By.id("tr_log")),4000)).click()      
    }
    
    await driver.executeScript("window.scrollTo(0,0)")
    //await sleep(5)
    await (await driver.wait(until.elementLocated(By.id("item_date2")),4000))
    const elements = await driver.findElements(By.id("item_date2"))
    assert(elements.length)

    await sleep(2000)
 

    if (webVersion=="new"){
  
      assert(await driver.findElement(By.id("item_date2")).getText() != 0)
      {
        const elements = await driver.findElements(By.id("inst_cpu"))
        assert(elements.length)
      }
      assert((await driver.findElement(By.id("inst_cpu")).getText() != "")&&(await driver.findElement(By.id("inst_cpu")).getText() != "0%"))
      {
        const elements = await driver.findElements(By.id("inst_memory"))
        assert(elements.length)
      }
      assert((await driver.findElement(By.id("inst_memory")).getText() != "")&&(await driver.findElement(By.id("inst_memory")).getText() != "0%"))
      {
        const elements = await driver.findElements(By.id("inst_temperature"))
        assert(elements.length)
      }
      assert((await driver.findElement(By.id("inst_temperature")).getText() != "")&&(await driver.findElement(By.id("inst_temperature")).getText() != "0ºC"))
      
      //await driver.findElement(By.css(".unappend:nth-child(8) > span")).click()
      await (await driver.wait(until.elementLocated(By.css("#lefter > span > li:nth-child(2) > a > span > b  ")),4000)).click()     //SFP

      await (await driver.wait(until.elementLocated(By.css("#lefter > span > li:nth-child(3) > a > span > b  ")),4000)).click()     //LOG
      
      await (await driver.wait(until.elementLocated(By.id("soce_ip_config")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("soce_sw_config")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.id("soce_configurations_manager")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.id("soce_system_monitor")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("soce_node_table")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.id("nginx")),4000)).click()
     
      await (await driver.wait(until.elementLocated(By.id("ssh")),4000)).click()
      
      await (await driver.wait(until.elementLocated(By.xpath('//*[@id="snmpd"]')),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("auth")),4000)).click()
    
      await (await driver.wait(until.elementLocated(By.id("ptp4l")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("phc2sys")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("ntp")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("igmp_snooping")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("fail2ban")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("platform_preinit")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("iface_config")),4000)).click()

      await (await driver.wait(until.elementLocated(By.id("platform_init")),4000)).click()

      //await (await driver.wait(until.elementLocated(By.id("sfp_monitor")),4000)).click()

      //await (await driver.wait(until.elementLocated(By.id("tap_0_get_stamp_data")),4000)).click()

      //await (await driver.wait(until.elementLocated(By.id("tap_1_get_stamp_data")),4000)).click()
  
      /*await (await driver.wait(until.elementLocated(By.css("#lefter > span > li:nth-child(4) > a > span > b  ")),4000)).click()  //GPS 
      await sleep(2000)
      var latitud = await driver.findElement(By.id("latitude")).getAttribute("value").then((value) => { return value; });
      var longitud = await driver.findElement(By.id("longitude")).getAttribute("value").then((value) => { return value; });
      var altura = await driver.findElement(By.id("altHAE")).getAttribute("value").then((value) => { return value; });
      console.log("GPS - position: "+latitud+" "+longitud+" "+altura);
      
      await sleep(1000)
      driver.takeScreenshot().then(function(data) {
        writeScreenshot(data, 'out1.png');
      });      
      */
      
    } else {
      assert(await driver.findElement(By.id("item_date2")).getText() != "")
      {
        const elements = await driver.findElements(By.id("item_cpu2"))
        assert(elements.length)
      }
      assert((await driver.findElement(By.id("item_cpu2")).getText() != "")&&(await driver.findElement(By.id("item_cpu2")).getText() != "0%"))
      {
        const elements = await driver.findElements(By.id("item_c"))
        assert(elements.length)
      }
      assert((await driver.findElement(By.id("item_c")).getText() != "")&&(await driver.findElement(By.id("item_c")).getText() != "0%"))
      {
        const elements = await driver.findElements(By.id("item_e"))
        assert(elements.length)
      }
      assert((await driver.findElement(By.id("item_e")).getText() != "")&&(await driver.findElement(By.id("item_e")).getText() != "0ºC"))
      
      //await driver.findElement(By.css(".unappend:nth-child(8) > span")).click()
      await (await driver.wait(until.elementLocated(By.css(".unappend:nth-child(8) > span")),4000)).click()  

      await (await driver.wait(until.elementLocated(By.css(".unappend:nth-child(9) > span")),4000)).click()

      await (await driver.wait(until.elementLocated(By.css("#ptp4l > b")),4000)).click()

      await (await driver.wait(until.elementLocated(By.css("#phc2sys > b")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.css("#lighttpd > b")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.css("#mstpd_launcher > b")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.css("#ssh > b")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.css("#auth > b")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.css("#audits > b")),4000)).click()
  
      await (await driver.wait(until.elementLocated(By.id("item_date2")),4000))
      const elements = await driver.findElements(By.id("item_date2"))
      assert(elements.length)
  
      assert(await driver.findElement(By.id("item_date2")).getText() != "")

    }    
    

  } finally {
    await driver.quit();
  }
})();