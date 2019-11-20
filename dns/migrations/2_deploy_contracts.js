const Services = artifacts.require("Services");
const Types = artifacts.require("Types");

module.exports = function(deployer) {
    deployer.deploy(Services);
    deployer.deploy(Types);
};
