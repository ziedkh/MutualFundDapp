const DMF = artifacts.require("DMF");
const Proxy = artifacts.require("proxy");

module.exports = function(deployer) {

 deployer.deploy(Proxy);
 deployer.deploy(DMF);


};
