pragma solidity ^0.5.0;

contract Types {
    mapping(string => Data) private info;
    address private owner;

    struct Data {
        string validator;
        string publicKey;
    }

    constructor() public {
        owner = msg.sender;
        info['age'] = Data('http://localhost:7000/api/sign/egov', 'd1fd9efdfaf631c2bdb87ecf9989f5bb98d15fe4fe4bc6e64e77dd84aa5cff6cd00a73720c9690d030aa7c704959ce4b252772bac8719c72bb56e8d96f212904af9c78c6dfb4d3a9fe4a8f6e555e7e07d24d348eeaf0bb47fe176cbe070380ef694153f809cd7032984074f5bcb6eaf618ec357b0ced608d1d1eae3214f790ff');
        info['name'] = Data('http://localhost:7000/api/sign/egov', 'd1fd9efdfaf631c2bdb87ecf9989f5bb98d15fe4fe4bc6e64e77dd84aa5cff6cd00a73720c9690d030aa7c704959ce4b252772bac8719c72bb56e8d96f212904af9c78c6dfb4d3a9fe4a8f6e555e7e07d24d348eeaf0bb47fe176cbe070380ef694153f809cd7032984074f5bcb6eaf618ec357b0ced608d1d1eae3214f790ff');
        info['uni'] = Data('http://localhost:7000/api/sign/ministry', 'ac63f2ce380bbb206474b0a92417f301b9e0f33bb6441fde3f7e5580e94fc6cb6f2d26974f341422d93f84e7b6c631ed8a4c0881b9bc9473447e7481e05ae40eb56501e69c7e87c40c80f6157137553c305c3e647f42b72fb32197932e59f4355663273727df5d32115d1a4945a40e62e42ac0a44e283f733ff3f8d9a0aa1093');
    }

    function setValidator(string memory claimType, string memory link, string memory publicKey) public onlyOwner {
        info[claimType] = Data(link, publicKey);
    }

    function getValidator(string memory attributeType) public view returns(string memory) {
        return info[attributeType].validator;
    }

    function getPublicKey(string memory attributeType) public view returns(string memory) {
        return info[attributeType].publicKey;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
}
