const Dns = artifacts.require("Dns");

module.exports = function(deployer) {
    deployer.deploy(Dns);
};
