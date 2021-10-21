## Dependencies
Zokrates 0.5.1

## Deploying Smart Contracts
```
npm install -g truffle
truffle compile
truffle migrate
```

- Step 1: open truffle-config.js for each contract, edit the address for the contract's owner
- Step 2: deploy IdP and DNS contracts
- Step 3: Edit Beerclub.sol and Library.sol with the address of deployed Idp and DNS
- Step 4: deploy Beerclub and Library contracts

## Client Apps
- `cp dns/build/contracts/Dns.json identity-provider/client-app/src/abis`
- Run `npm start` inside each client-app folder to start

## Validators
If you want to run validators on local:
- start app:
  + cd to Validators and run `dotnet run`
  + or, `docker run -d -p 5000:80 --name validators dakennguyen/validators:2.0`
  + checkhealth: http://localhost:5000/api/sign/egov?data=25
- edit DNS.sol's constructor to the corresponding api address

## IdP
Via IdP's client app, submit attributes to IdP contract. For example:
```
age: 25
name: khoa
uni: vgu
```

## Users
Generate proof:
- cd to `beer-club/zokrates`:
```
# $age_hash $age
./peggy.sh 0x07027baf0a959d3045dfc490f7866d1aae5fd9214119e0bd0b7a21cc87f436f3 25
```
- cd to `library/zokrates`:
```
# $name_hash $uni_hash $name $uni
./peggy.sh 0x7ee6282d5ca83a2a577b7567fa848b6a545f61eefaee5f6fb9f31411eea5cb25 0x18a69c85d08ebf354bc47e70a83da0645fa96ed35aaa60ea0350d368160d646ab khoa vgu
```
