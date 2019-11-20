pragma solidity ^0.5.0;

contract Idp {
    mapping(address => Data) private clients;
    uint private clientsCount;
    address dnsServices = 0x86629d9B3f37786438206E3D0400f466901bd229;

    struct Data {
        Claim[] data;
        bool registered;
        uint dataCount;
    }

    struct Claim {
        string claimType;
        string claimValue;
    }

    constructor() public {
        // Address of Account 0
        clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].data.push(Claim('age', '22'));
        clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].data.push(Claim('name', 'khoa'));
        clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].registered = true;
        clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].dataCount = 2;
    }

    function getRegistered(address addr) public returns(bool) {
        return clients[addr].registered;
    }

    function register() public {
        require(!clients[msg.sender].registered, "Already registered");
        clients[msg.sender].registered = true;
        clientsCount++;
    }

    function addClaim(string memory claimType, string memory claimValue) public hasRegistered() {
        clients[msg.sender].data.push(Claim(claimType, claimValue));
        clients[msg.sender].dataCount++;
    }

    function sendData(address service) public hasRegistered() returns(bool, bytes memory) {
        string memory tmp = 'Data:';
        string memory allowedClaims = getAllowedClaims(service);
        for (uint i = 0; i < clients[msg.sender].dataCount; i++) {
            if (contains(clients[msg.sender].data[i].claimType, allowedClaims)) {
                tmp = string(abi.encodePacked(tmp, ' ', clients[msg.sender].data[i].claimValue));
            }
        }
        (bool success, bytes memory result) = service.call(abi.encodeWithSignature("setData(address,string)", msg.sender, tmp));
        return (success, result);
    }

    function getAllClaims() public hasRegistered() returns(string memory) {
        string memory tmp = '';
        for (uint i = 0; i < clients[msg.sender].dataCount; i++) {
            tmp = string(abi.encodePacked(tmp, ' ', clients[msg.sender].data[i].claimType, ':', clients[msg.sender].data[i].claimValue));
        }
        return tmp;
    }

    modifier hasRegistered() {
        require(clients[msg.sender].registered, "Not register");
        _;
    }

    function contains(string memory what, string memory where) private returns(bool) {
        bytes memory whatBytes = bytes (what);
        bytes memory whereBytes = bytes (where);
        
        if (whereBytes.length < whatBytes.length) return false;

        bool found = false;
        for (uint i = 0; i <= whereBytes.length - whatBytes.length; i++) {
            bool flag = true;
            for (uint j = 0; j < whatBytes.length; j++)
            if (whereBytes [i + j] != whatBytes [j]) {
                flag = false;
                break;
            }
            if (flag) {
                found = true;
                break;
            }
        }
        return found;
    }

    function getAllowedClaims(address addr) private returns(string memory) {
        (bool success, bytes memory result) = dnsServices.call(abi.encodeWithSignature("serviceProviders(address)", addr));
        return abi.decode(result, (string));
    }

    //function test2(uint i) public returns(string memory, string memory) {
        //return (clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].data[i].claimType, clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].data[i].claimValue);
    //}
}
