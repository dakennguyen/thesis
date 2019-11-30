pragma solidity ^0.5.0;

contract Idp {
    mapping(address => Data) private clients;
    uint private clientsCount;
    //address dnsServices = 0x86629d9B3f37786438206E3D0400f466901bd229;

    struct Data {
        Attribute[] data;
        bool registered;
        uint dataCount;
    }

    struct Attribute {
        string attributeType;
        string attributeValue;
        string signature;
    }

    constructor() public {
        address a0 = 0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d;
        // address a0 = 0x5963D7FA276fA797f174752A852AbfE32Db791D6;
        clients[a0].data.push(Attribute('age', '22', '99699b7dada4c013faccd4eb708c7b444cbcbfb5107032916b2a55307042ecf6699522cec6b893c30aa694d40084431984b8e04a63625883226d24dfba89c041e3031fc9ad96a76e6789127fb37f9dc6e9671505f41face504322dd57fe3916c7b71c83f23aae9cdadbab1dfa0074ea557ca6f212daadc276bcc868cba794a31'));
        clients[a0].data.push(Attribute('name', 'khoa', 'cd81eea6c1f88997bbdb04b9647fba1891874aea0cf66d435fa915c9876bdd7b577edb2fe976d1825e2cdcc23a2fa826fed10840ed0e79a90b277489dc413a774a27e1f4751145d4e4df13fa081ec2dee0ab1cf23e7ac39a87f9edf9ab88040a906cec1a75870a6857b94f2ec139bdd20e9e1691539266f31ac98daea31d9b6e'));
        clients[a0].registered = true;
        clients[a0].dataCount = 2;
    }

    function getRegistered() public view returns(bool) {
        return clients[msg.sender].registered;
    }

    function register() public {
        require(!clients[msg.sender].registered, "Already registered");
        clients[msg.sender].registered = true;
        clientsCount++;
    }

    function addAttribute(string memory attributeType, string memory attributeValue, string memory signature) public onlyClient() {
        clients[msg.sender].data.push(Attribute(attributeType, attributeValue, signature));
        clients[msg.sender].dataCount++;
    }

    function sendData(address service, string memory allowedAttributes) public onlyClient() returns(bool, bytes memory) {
        string memory tmp = '';
        uint count = 0;
        //string memory allowedAttributes = getAllowedAttributes(service);
        for (uint i = 0; i < clients[msg.sender].dataCount; i++) {
            if (contains(clients[msg.sender].data[i].attributeType, allowedAttributes)) {
                count++;
                tmp = string(abi.encodePacked(
                    tmp,
                    clients[msg.sender].data[i].attributeType, ":",
                    clients[msg.sender].data[i].attributeValue, ':',
                    clients[msg.sender].data[i].signature, ' '
                ));
            }
        }
        (bool success, bytes memory result) = service.call(abi.encodeWithSignature("setData(address,string,uint256)", msg.sender, tmp, count));
        return(success, result);
    }

    function getAllAttributes() public view onlyClient() returns(string memory) {
        string memory tmp = '';
        for (uint i = 0; i < clients[msg.sender].dataCount; i++) {
            tmp = string(abi.encodePacked(tmp, ' ', clients[msg.sender].data[i].attributeType, ':', clients[msg.sender].data[i].attributeValue));
        }
        return tmp;
    }

    modifier onlyClient() {
        require(clients[msg.sender].registered, "Not register");
        _;
    }

    function contains(string memory what, string memory where) private pure returns(bool) {
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

    //function getAllowedAttributes(address addr) public returns(string memory) {
        //(bool success, bytes memory result) = dnsServices.call(abi.encodeWithSignature("serviceProviders(address)", addr));
        //return abi.decode(result, (string));
    //}

    //function test2(uint i) public returns(string memory, string memory) {
        //return (clients[a0].data[i].attributeType, clients[a0].data[i].attributeValue);
    //}
}
