var VehicleContract = artifacts.require("./VehicleContract.sol");

module.exports = function(deployer){
  deployer.deploy(VehicleContract);
};
