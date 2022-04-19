Instrucciones para Windows 10
=============================
VS Code:

Cargar esta carpeta y ejecutar en la terminal: npm install selenium-webdriver
Para ejecutar script: node ./file.js

Instrucciones para Linux
========================

sudo apt-get install -y nodejs
node -v

# El gestor de paquetes YARN sustituye a NPM

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

yarn add minimist
yarn add selenium-webdriver

Instalación Geckodriver (Firefox)
=================================

https://github.com/mozilla/geckodriver/releases/

descomprimo y lo copio en /usr/local/bin


Comprobar Instalación
=====================

test.js:

const http = require('http');
const port = 8080;
const server = http.createServer((req, res) => {
   res.writeHead(200, {'Content-Type': 'text/plain'});
   res.end('Hello World!\n');
});
server.listen(port, () => {
  console.log(`Node.js server listening on port ${port}`);
});


Execute:

node --inspect test.js


localhost:8080
