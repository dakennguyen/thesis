pragma solidity ^0.5.0;

contract Services {
    mapping (address => Value) public serviceProviders;

    struct Value {
        string types;
        uint typesCount;
    }

    constructor() public {
        // Address of Beer Club
        serviceProviders[0xdbD8635f1b03e084F7b1A9E1a967E8b87605c96B] = Value('age', 1);
        // Address of Library
        serviceProviders[0x79D602F576243c04A2378b01B0C0C7d3e95A7827] = Value('university name', 2);
    }

    function addClaim(string memory claimType) public {
        serviceProviders[msg.sender].types = (serviceProviders[msg.sender].typesCount > 0) ? string(abi.encodePacked(serviceProviders[msg.sender].types, ' ', claimType)) : claimType;
        serviceProviders[msg.sender].typesCount++;
    }
}
