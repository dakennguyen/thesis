pragma solidity ^0.5.0;

contract Idp {
    mapping(address => Data) private clients;
    uint private clientsCount;
    address dnsServices = 0x86629d9B3f37786438206E3D0400f466901bd229;

    struct Data {
        Attribute[] data;
        bool registered;
        uint dataCount;
    }

    struct Attribute {
        string attributeType;
        string attributeValue;
        string hash;
    }

    constructor() public {
        // Address of Account 0
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data.push(Attribute('age', '22', 'hash1'));
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data.push(Attribute('name', 'khoa', 'hash2'));
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].registered = true;
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].dataCount = 2;
    }

    //function getRegistered(address addr) public returns(bool) {
        //return clients[addr].registered;
    //}

    function register() public {
        require(!clients[msg.sender].registered, "Already registered");
        clients[msg.sender].registered = true;
        clientsCount++;
    }

    function addAttribute(string memory attributeType, string memory attributeValue, string memory hash) public onlyClient() {
        clients[msg.sender].data.push(Attribute(attributeType, attributeValue, hash));
        clients[msg.sender].dataCount++;
    }

    //function sendData(address service) public onlyClient() returns(bool, bytes memory) {
        //string memory tmp = 'Data:';
        //string memory allowedClaims = getAllowedClaims(service);
        //for (uint i = 0; i < clients[msg.sender].dataCount; i++) {
            //if (contains(clients[msg.sender].data[i].attributeType, allowedClaims)) {
                //tmp = string(abi.encodePacked(tmp, ' ', clients[msg.sender].data[i].attributeValue));
            //}
        //}
        //(bool success, bytes memory result) = service.call(abi.encodeWithSignature("setData(address,string)", msg.sender, tmp));
        //return (success, result);
    //}

    //function getAllClaims() public onlyClient() returns(string memory) {
        //string memory tmp = '';
        //for (uint i = 0; i < clients[msg.sender].dataCount; i++) {
            //tmp = string(abi.encodePacked(tmp, ' ', clients[msg.sender].data[i].attributeType, ':', clients[msg.sender].data[i].attributeValue));
        //}
        //return tmp;
    //}

    //modifier onlyClient() {
        //require(clients[msg.sender].registered, "Not register");
        //_;
    //}

    //function contains(string memory what, string memory where) private returns(bool) {
        //bytes memory whatBytes = bytes (what);
        //bytes memory whereBytes = bytes (where);
        
        //if (whereBytes.length < whatBytes.length) return false;

        //bool found = false;
        //for (uint i = 0; i <= whereBytes.length - whatBytes.length; i++) {
            //bool flag = true;
            //for (uint j = 0; j < whatBytes.length; j++)
            //if (whereBytes [i + j] != whatBytes [j]) {
                //flag = false;
                //break;
            //}
            //if (flag) {
                //found = true;
                //break;
            //}
        //}
        //return found;
    //}

    //function getAllowedClaims(address addr) public returns(string memory) {
        //(bool success, bytes memory result) = dnsServices.call(abi.encodeWithSignature("serviceProviders(address)", addr));
        //return abi.decode(result, (string));
    //}

    //function test2(uint i) public returns(string memory, string memory) {
        //return (clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data[i].attributeType, clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data[i].attributeValue);
    //}
}
