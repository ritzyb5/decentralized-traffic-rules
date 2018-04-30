var vehicleContract = artifacts.require("./vehicleContract.sol");

module.exports = function(deployer){
  deployer.deploy(vehicleContract);
};
