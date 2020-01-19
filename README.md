## Deploying Smart Contracts
- Step 1: open truffle-config.js for each contract, edit the address for the contract's owner
- Step 2: deploy IdP and DNS contracts
- Step 3: Edit Beerclub.sol and Library.sol with the address of deployed Idp and DNS
- Step 4: deploy Beerclub and Library contracts

## Client Apps
- Copy Dns.json from dns/build/contracts into identity-provider/client-app/src/abis 
- Run 'npm start' inside each client-app folder to start
