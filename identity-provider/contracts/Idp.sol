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
        // Geth: Address of Account 0
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data.push(Attribute('age', '22', 'JHxzfiH+SgM230bKbDmB4uysBHutl9jgZq4bCwpka+4+fUd6bvKxFTV942ar7Dec3dwWf1tod3XOi7ZNugS5jR7mE48nUc1FxEyYNS7MmoDFXd+bv3cJfa3aJWHRX6aQZO4DihsrZ2O0tL6FQ8TbROyDUGGKsVdoZAEUoRdJdf0KD11tQinybrL5jk00TZCubytDBmSwrOcCq7rohHqA+dZ0+p5XZgsqpTWgs84JwBDBjGjjiDOhClRK/O4n9cP8pE2Bjizx8lCb2OKlKQR/QLk23Ajyb+/m3MWzBkCkmu6ZezTUWgEKpKMhXIOKnsxd2D451LTUKSAUUlpUqEfLow=='));
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data.push(Attribute('name', 'khoa', 'jFlUbuhkLRgERZ8abL0uPFmssNoc5x77lmq3AaF+zJcFgK2eSkoValRuKguj8ksVktAn2Q6xpihlZX4CJoj06ZSfV7ggLwGjVYBwNehm+KT2EI2Rf5mXcIHRSjoUHy88187PrTQHz5Refq8hcIXL5U9dzvqturL4zBvrH2DH2tmM21N4ApJRLLSzZFFp7fmWZtJgwCZQjJMd6OTFLWjR2P9LztAfxkJ1G3RryqObsijHK1t5uvR1UJFssDcA9ZJbbFpIzjaE8bYdcSkDRwvbh3o8p/MTtOMe2Ef9vcVAdLSIj+AhwLaxUr0zWWrNMt/NsB+RcJjm3fC5asZRVqffWQ=='));
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].registered = true;
        clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].dataCount = 2;
        // Truffle: Address of Account 0
        //clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].data.push(Attribute('age', '22', 'JHxzfiH+SgM230bKbDmB4uysBHutl9jgZq4bCwpka+4+fUd6bvKxFTV942ar7Dec3dwWf1tod3XOi7ZNugS5jR7mE48nUc1FxEyYNS7MmoDFXd+bv3cJfa3aJWHRX6aQZO4DihsrZ2O0tL6FQ8TbROyDUGGKsVdoZAEUoRdJdf0KD11tQinybrL5jk00TZCubytDBmSwrOcCq7rohHqA+dZ0+p5XZgsqpTWgs84JwBDBjGjjiDOhClRK/O4n9cP8pE2Bjizx8lCb2OKlKQR/QLk23Ajyb+/m3MWzBkCkmu6ZezTUWgEKpKMhXIOKnsxd2D451LTUKSAUUlpUqEfLow=='));
        //clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].data.push(Attribute('name', 'khoa', 'jFlUbuhkLRgERZ8abL0uPFmssNoc5x77lmq3AaF+zJcFgK2eSkoValRuKguj8ksVktAn2Q6xpihlZX4CJoj06ZSfV7ggLwGjVYBwNehm+KT2EI2Rf5mXcIHRSjoUHy88187PrTQHz5Refq8hcIXL5U9dzvqturL4zBvrH2DH2tmM21N4ApJRLLSzZFFp7fmWZtJgwCZQjJMd6OTFLWjR2P9LztAfxkJ1G3RryqObsijHK1t5uvR1UJFssDcA9ZJbbFpIzjaE8bYdcSkDRwvbh3o8p/MTtOMe2Ef9vcVAdLSIj+AhwLaxUr0zWWrNMt/NsB+RcJjm3fC5asZRVqffWQ=='));
        //clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].registered = true;
        //clients[0x5963D7FA276fA797f174752A852AbfE32Db791D6].dataCount = 2;
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
        //return (clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data[i].attributeType, clients[0x8C02816311bCfeEe76fB6b9C20AF38BC477f3D9d].data[i].attributeValue);
    //}
}
