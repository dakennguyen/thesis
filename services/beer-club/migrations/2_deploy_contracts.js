const Beerclub = artifacts.require("Beerclub");

module.exports = function(deployer) {
  deployer.deploy(Beerclub);
};
