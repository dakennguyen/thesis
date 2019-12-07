pragma solidity ^0.5.0;

contract Idp {
    mapping(address => string) private services;
    mapping(address => Data) private clients;
    uint private clientsCount;

    struct Data {
        mapping(string => Attribute) data;
        bool registered;
    }

    struct Attribute {
        bytes32 hash;
        bytes signature;
    }

    constructor() public {
        address a0 = 0x720CeD90E4D3F188Be72EFE25E2c2A084b50dc2C;
        (clients[a0].data)['age'] = Attribute(hex'd9d550f59b03bec9d4d4b0694ef67144a2841c2e6c41eff95c581244753749d2', hex'2e00152c2eafed70baead8fec522c3fcc3203f40b2b85aa375200b0219607bcd59798cce6124dca6ee928ad5109993afa5aa07fbf7dc79ab66ed7c79f6f9a020e75634b6e522fe86d36789c8d3599e487b6ebed6225014c21fb155c891d0ee4a3c8373f47e1d9fed6245ba32b2fb9971fd72f97cb78e9fa0f57bb5c035ce3f53');
        (clients[a0].data)['name'] = Attribute(hex'7ee6282d5ca83a2a577b7567fa848b6a545f61eefaee5f6fb9f31411eea5cb25', hex'71ad3639f14d7399f237a1d419d4f6dacc361685e8ca837bfc70aed3bd118a5072b338c81bb1865519487e68fa4f6ccd8af9b39c1f3931ef55c10f0b07f88e88a6893519217347ba06b87ec9f841b3ecbba0f6f537c5c2af550db985c0a61d2d777f792e8a442a73d0e490191633e5d629d9fa1ca70dcf7caefecad6af3a0432');
        clients[a0].registered = true;
    }

    function setService(string memory ipfsHash) public {
        services[msg.sender] = ipfsHash;
    }

    function getService(address addr) public onlyClient view returns(string memory) {
        return services[addr];
    }

    function getRegistered() public view returns(bool) {
        return clients[msg.sender].registered;
    }

    function getData(address addr, string memory attributeType) public view returns(bytes memory, bytes memory) {
        return ((clients[addr].data)[attributeType].hash, (clients[addr].data)[attributeType].signature);
    }

    function register() public {
        require(!clients[msg.sender].registered, "Already registered");
        clients[msg.sender].registered = true;
        clientsCount++;
    }

    function add(string memory attributeType, string memory hash, string memory signature) public onlyClient {
        (clients[msg.sender].data)[attributeType] = Attribute(fromHex(hash), fromHex(signature));
    }

    modifier onlyClient() {
        require(clients[msg.sender].registered, "Not register");
        _;
    }

    // Convert an hexadecimal character to their value
    function fromHexChar(uint8 c) private pure returns (uint8) {
        if (byte(c) >= byte('0') && byte(c) <= byte('9')) {
            return c - uint8(byte('0'));
        }
        if (byte(c) >= byte('a') && byte(c) <= byte('f')) {
            return 10 + c - uint8(byte('a'));
        }
        if (byte(c) >= byte('A') && byte(c) <= byte('F')) {
            return 10 + c - uint8(byte('A'));
        }
    }
    
    // Convert an hexadecimal string to raw bytes
    function fromHex(string memory s) private pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length%2 == 0); // length must be even
        bytes memory r = new bytes(ss.length/2);
        for (uint i=0; i<ss.length/2; ++i) {
            r[i] = byte(fromHexChar(uint8(ss[2*i])) * 16 + fromHexChar(uint8(ss[2*i+1])));
        }
        return r;
    }
}
