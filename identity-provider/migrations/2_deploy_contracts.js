const Idp = artifacts.require("Idp");

module.exports = function(deployer) {
    deployer.deploy(Idp);
};
