//Parte a modificar por el usuario, si uno de los campos no hay que elegir nada poner "empty"
var port_num_1="1"
var port_type_1="Hybrid"    //Access, Trunk, Hybrid
var accep_frames_1="Admit all" //Admit all , Admit untagged and priority , Admit tagged, Admit untagged
var ing_filt_1="True" //False , True
var egr_tag_1="Custom untagging" //Untag port , Tag all, Untag all, Custom untagging 
var prio_tag_eg_1="Original" //Original, Merged, Without, Depend-on-port-conf
var hybird_port_type_1="C-port" //Unaware, C-port, S-port, S-custom port
var PVID_1="100"


var port_num_2="2"
var port_type_2="Trunk"    //Access, Trunk, Hybrid
var accep_frames_2="Admit all" //Admit all , Admit untagged and priority , Admit tagged, Admit untagged
var ing_filt_2="empty" //False , True
var egr_tag_2="Tag all" //Untag port , Tag all, Untag all, Custom untagging 
var prio_tag_eg_2="Original" //Original, Merged, Without, Depend-on-port-conf
var hybird_port_type_2="empty" //Unaware, C-port, S-port, S-custom port
var PVID_2="200"

var num_vlan_entries=2 // si añadimos mas de dos vlan_entries hay que añadir mas grupos de variables vlan_id, vlan_name, egr_ports
var vlan_id=new Array(num_vlan_entries)
var vlan_name=new Array(num_vlan_entries)
var egr_ports=new Array(num_vlan_entries)
var untagged_port=new Array(num_vlan_entries)

vlan_id[0]="100"
vlan_name[0]="100"
egr_ports[0]="SWITCH/J1A-J1B"  //si los puertos son consecutivos por ejemplo desde J1A a J1C escribimo SWICTH/J1A-JIC, si el J1B no estuviera entonces escribimos SWICTH/J1A,SWICTH/J1C. Todos los que queramos con la ,
untagged_port[0]="empty"
vlan_id[1]="200"
vlan_name[1]="200"
egr_ports[1]="SWITCH/J1A-J1B" 
untagged_port[1]="empty"
vlan_id[2]="300"
vlan_name[2]="300"
egr_ports[2]="SWITCH/J1B" 
untagged_port[2]="empty"


// Generated by Selenium IDE
const { Builder, By, Key, until } = require('selenium-webdriver');
const assert = require('assert');

'use strict';

let jsonData = require('../constants.json');
const { exit } = require('process');

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

(async function example() {

  var webVersion = "new"

  //configuracion del puerto VLAN

    
  port_num_1=parseInt(port_num_1)+1
  port_num_2=parseInt(port_num_2)+1
  port_num_1="tr["+port_num_1+"]"
  port_num_2="tr["+port_num_2+"]"
 
  if (true){
    if (port_type_1=="Hybrid") {
      port_type_1="option[4]"
      
    } 
    if (port_type_1=="Access") {
      port_type_1="option[2]"
    } 
    if (port_type_1=="Trunk") {
      port_type_1="option[3]"
    } 
  

    if (accep_frames_1=="Admit all") {
      accep_frames_1="option[2]"
    }
    if (accep_frames_1=="Admit untagged and priority") {
      accep_frames_1="option[3]"
    }
    if (accep_frames_1=="Admit tagged") {
      accep_frames_1="option[4]"
    }
    if (accep_frames_1=="Admit untagged") {
      accep_frames_1="option[5]"
    }

    if (ing_filt_1=="False") {
      ing_filt_1="option[2]"
    }
    if (ing_filt_1=="True") {
      ing_filt_1="option[3]"
    }
    if (egr_tag_1=="Untag port") {
      egr_tag_1="option[2]"
    }
    if (egr_tag_1=="Tag all") {
      egr_tag_1="option[3]"
    } 
    if (egr_tag_1=="Untag all") {
      egr_tag_1="option[4]"
    } 
    if (egr_tag_1=="Custom untagging") {
      egr_tag_1="option[5]"
    } 

    if (prio_tag_eg_1=="Original") { //Original, Merged, Without, Depend-on-port-conf
        prio_tag_eg_1="option[2]"    
    }
    if (prio_tag_eg_1=="Merged") { 
      prio_tag_eg_1="option[3]"    
    } 
    if (prio_tag_eg_1=="Without") { 
      prio_tag_eg_1="option[4]"    
    }
    if (prio_tag_eg_1=="Depend-on-port-conf") {  
      prio_tag_eg_1="option[5]"    
    }
    if ( hybird_port_type_1=="Unaware") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_1="option[2]"
    }
    if ( hybird_port_type_1=="C-port") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_1="option[3]"
    }
    if ( hybird_port_type_1=="S-port") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_1="option[4]"
    }
    if ( hybird_port_type_1=="S-custom port") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_1="option[5]"
    }
    if (port_type_2=="Hybrid") {
      port_type_2="option[4]"
    } 
    if (port_type_2=="Access") {
      port_type_2="option[2]"
    } 
    if (port_type_2=="Trunk") {
      port_type_2="option[3]"
    } 
   
  
    if (accep_frames_2=="Admit all") {
      accep_frames_2="option[2]"
    }
    if (accep_frames_2=="Admit untagged and priority") {
      accep_frames_2="option[3]"
    }
    if (accep_frames_2=="Admit tagged") {
      accep_frames_2="option[4]"
    }
    if (accep_frames_2=="Admit untagged") {
      accep_frames_2="option[5]"
    }
  
    if (ing_filt_2=="False") {
      ing_filt_2="option[2]"
    }
    if (ing_filt_2=="True") {
      ing_filt_2="option[3]"
    }
    if (egr_tag_2=="Untag port") {
      egr_tag_2="option[2]"
    }
    if (egr_tag_2=="Tag all") {
      egr_tag_2="option[3]"
    } 
    if (egr_tag_2=="Untag all") {
      egr_tag_2="option[4]"
    } 
    if (egr_tag_2=="Custom untagging") {
      egr_tag_2="option[5]"
    } 
  
    if (prio_tag_eg_2=="Original") { //Original, Merged, Without, Depend-on-port-conf
        prio_tag_eg_2="option[2]"    
    }
    if (prio_tag_eg_2=="Merged") { 
      prio_tag_eg_2="option[3]"    
    } 
    if (prio_tag_eg_2=="Without") { 
      prio_tag_eg_2="option[4]"    
    }
    if (prio_tag_eg_2=="Depend-on-port-conf") {  
      prio_tag_eg_2="option[5]"    
    }
    if ( hybird_port_type_2=="Unaware") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_2="option[2]"
    }
    if ( hybird_port_type_2=="C-port") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_2="option[3]"
    }
    if ( hybird_port_type_2=="S-port") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_2="option[4]"
    }
    if ( hybird_port_type_2=="S-custom port") {//Unaware, C-port, S-port, S-custom port
      hybird_port_type_2="option[5]"
    }
  
}

  
  let driver = await new Builder().forBrowser('firefox').build();
  try {
	await driver.get("http://"+jsonData.user_basic+":"+jsonData.pass_basic+"@"+jsonData.ip+"/")
	await driver.manage().window().setRect(700,700)
    //await sleep(10000)
    
    await driver.wait(until.elementLocated(By.xpath("/html/body/div/header/nav/div/ul/li[3]")),10000).click()
    await driver.wait(until.elementLocated(By.xpath("//ul[@id='lefter']/span/li[2]/a/span/b")),10000).click()
    await driver.wait(until.elementLocated(By.xpath("//ul[@id='lefter']/span/li[2]/a/span/b")),10000).click()

    //ponermos el PVID en el J1A
    await driver.wait(until.elementLocated(By.xpath("//table[@id='table_vlanPortConfig_SWITCH']/tbody/"+port_num_1+"/td[2]/input")),10000).click()
    await driver.wait(until.elementLocated(By.xpath("//table[@id='table_vlanPortConfig_SWITCH']/tbody/"+port_num_1+"/td[2]/input")),10000).clear()
    await driver.wait(until.elementLocated(By.xpath("//table[@id='table_vlanPortConfig_SWITCH']/tbody/"+port_num_1+"/td[2]/input")),10000).sendKeys(PVID_1)
    //ponemos el Porttype en el J1A

    if (port_type_1!="empty")
    {  await (await driver.wait(until.elementLocated(By.id("portType")),20000)).click()
    {
      const dropdown = await driver.findElement(By.id("portType"))
      await dropdown.findElement(By.xpath(" /html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_1+"/td[5]/select/"+port_type_1)).click() 
    }
  }
  
      //ponemos el Acceptable frame types en el J1A
      if (accep_frames_1!="empty")
      { 
      await (await driver.wait(until.elementLocated(By.id("acceptableFrameTypes")),20000)).click()
      {
        const dropdown = await driver.findElement(By.id("acceptableFrameTypes"))
        await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_1+"/td[6]/select/"+accep_frames_1)).click() 
      }
      }

      
      //ponemos el ingress filtering en el J1A
      if (ing_filt_1!="empty")
      { 
      await (await driver.wait(until.elementLocated(By.id("ingressFiltering")),20000)).click()
      {
        const dropdown = await driver.findElement(By.id("ingressFiltering"))
        await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_1+"/td[7]/select/"+ing_filt_1)).click() 
      } 
    }
      //ponemos el egress tagging mode en el J1A
      if (egr_tag_1!="empty")
      { 
      await (await driver.wait(until.elementLocated(By.id("egressTaggingMode")),20000)).click()
      {
        const dropdown = await driver.findElement(By.id("egressTaggingMode"))
        await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_1+"/td[8]/select/"+egr_tag_1)).click() 
      }
    }
      //ponemos el Priority tagged egress mode mode en el J1A
      if (prio_tag_eg_1!="empty")
      { 
      await (await driver.wait(until.elementLocated(By.id("priorityTaggedEgressMode")),20000)).click()
      {
        const dropdown = await driver.findElement(By.id("priorityTaggedEgressMode"))
        await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_1+"/td[9]/select/"+prio_tag_eg_1)).click() 
      }
    }
    
      //ponemos el hybrid port tyep mode mode en el J1A
      if (hybird_port_type_1!="empty")
      {
      await (await driver.wait(until.elementLocated(By.id("hybridPortType")),20000)).click()
      {
        const dropdown = await driver.findElement(By.id("hybridPortType"))
        await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_1+"/td[10]/select/"+hybird_port_type_1)).click() 
      }
    }
    //ponermos el PVID en el J1B
    await driver.wait(until.elementLocated(By.xpath("//table[@id='table_vlanPortConfig_SWITCH']/tbody/"+port_num_2+"/td[2]/input")),10000).click()
    await driver.wait(until.elementLocated(By.xpath("//table[@id='table_vlanPortConfig_SWITCH']/tbody/"+port_num_2+"/td[2]/input")),10000).clear()
    await driver.wait(until.elementLocated(By.xpath("//table[@id='table_vlanPortConfig_SWITCH']/tbody/"+port_num_2+"/td[2]/input")),10000).sendKeys(PVID_2)
    //ponemos el Porttype en el J1B

    if (port_type_2!="empty")
    {  await (await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[5]")),20000)).click()
    {
      const dropdown = await driver.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[5]"))
      await dropdown.findElement(By.xpath(" /html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[5]/select/"+port_type_2)).click() 
    }
  }

    //ponemos el Acceptable frame types en el J1B
    if (accep_frames_2!="empty")
    { 
    await (await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[6]")),20000)).click()
    {
      const dropdown = await driver.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[6]"))
      await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[6]/select/"+accep_frames_2)).click() 
    }
    }

  
    //ponemos el ingress filtering en el J1B
    if (ing_filt_2!="empty")
    { 
    await (await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[7]")),20000)).click()
    {
      const dropdown = await driver.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[7]"))
      await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[7]/select/"+ing_filt_2)).click() 
    } 
  }
    //ponemos el egress tagging mode en el J1B
    if (egr_tag_2!="empty")
    { 
    await (await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[8]")),20000)).click()
    {
      const dropdown = await driver.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[8]"))
      await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[8]/select/"+egr_tag_2)).click() 
    }
  }
    //ponemos el Priority tagged egress mode mode en el J1B
    if (prio_tag_eg_2!="empty")
    { 
    await (await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[9]")),20000)).click()
    {
      const dropdown = await driver.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[9]"))
      await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[9]/select/"+prio_tag_eg_2)).click() 
    }
  }
  
    //ponemos el hybrid port tyep mode mode en el J1B
    if (hybird_port_type_2!="empty")
    {
    await (await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[10]")),20000)).click()
    {
      const dropdown = await driver.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[10]"))
      await dropdown.findElement(By.xpath("/html/body/div/div[1]/section[2]/div[2]/div/section[1]/div/div[2]/div/table/tbody/"+port_num_2+"/td[10]/select/"+hybird_port_type_2)).click() 
    }
  }   

    await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[1]/h1/span[3]/button")),10000).click()


   

    await driver.wait(until.alertIsPresent());
    await sleep(2000)
    await driver.switchTo().alert().accept()    
    await sleep(2000)

    for (let step=0; step<num_vlan_entries;step++)
    {
          console.log(vlan_id[step])
          await driver.wait(until.elementLocated(By.xpath(" /html/body/div/div[1]/section[2]/div[2]/div/section[2]/div/div[3]/span/button ")),10000).click() //add vlan entry
          await sleep(2000)
          
          if (vlan_id[step]!="empty") {

            await driver.wait(until.elementLocated(By.css(" #table_newVlanEntry_params_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).click()
            await driver.wait(until.elementLocated(By.css(" #table_newVlanEntry_params_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).clear()
            await driver.wait(until.elementLocated(By.css(" #table_newVlanEntry_params_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).sendKeys(vlan_id[step])
            }
            if (vlan_name[step]!="empty") {
            await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_params_0 > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(2) > input:nth-child(1)")),10000).click()
            await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_params_0 > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(2) > input:nth-child(1)")),10000).clear()
            await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_params_0 > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(2) > input:nth-child(1)")),10000).sendKeys(vlan_name[step])    
            }  
            if (egr_ports[step]!="empty") {
            await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_egress_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).click()
            await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_egress_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).clear()
            await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_egress_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).sendKeys(egr_ports[step])    
            }    
            if (untagged_port[step]!="empty") {
              await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_untagged_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).click()
              await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_untagged_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).clear()
              await driver.wait(until.elementLocated(By.css("#table_newVlanEntry_untagged_0 > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > input:nth-child(1)")),10000).sendKeys(untagged_port[step])
              
            }

          await driver.wait(until.elementLocated(By.xpath("/html/body/div/div[1]/section[2]/div[2]/section/div/div[11]/div/button")),10000).click()


          await driver.wait(until.alertIsPresent());
          await sleep(2000)
          await driver.switchTo().alert().accept()    
          await sleep(2000)
    }
  
	//le damos permiso para arrancar al soce_generator
    const execSync_2 = require('child_process').execSync;
    const output_2 = execSync_2("echo "+ jsonData.pass_host +" | sudo -S touch /usr/local/start", { encoding: 'utf-8' });      


} finally {
    await driver.quit();
  }
})();

