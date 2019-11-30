pragma solidity ^0.5.0;

contract Types {
    mapping(string => string) private validators;
    //mapping(string => string) public publicKeys;
    address private owner;

    constructor() public {
        owner = msg.sender;
        validators['age'] = 'http://localhost:7000/api/sign/egov';
        validators['name'] = 'http://localhost:7000/api/sign/egov';
        validators['uni'] = 'http://localhost:7000/api/sign/ministry';
    }

    function setValidator(string memory claimType, string memory link) public onlyOwner {
        validators[claimType] = link;
    }

    function getValidator(string memory attributeType) public returns(string memory) {
        return validators[attributeType];
    }

    //function setPublicKeys(string memory claimType, string memory publicKey) public onlyOwner {
        //types[claimType] = publicKey;
    //}

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
}
