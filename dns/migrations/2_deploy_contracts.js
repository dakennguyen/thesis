const Services = artifacts.require("Services");

module.exports = function(deployer) {
  deployer.deploy(Services);
};
