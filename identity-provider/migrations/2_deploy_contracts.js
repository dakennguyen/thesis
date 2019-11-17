const Test = artifacts.require("Test");
const Idp = artifacts.require("Idp");

module.exports = function(deployer) {
    deployer.deploy(Test);
    deployer.deploy(Idp);
};
