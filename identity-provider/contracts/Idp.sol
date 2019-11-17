pragma solidity ^0.5.0;

contract Idp {

    mapping(address => Data) private clients;
    uint private clientsCount;

    address dnsServices = 0x132BA6EB88c34f7eb6262758e54cebeC0e18a64C;

    struct Data {
        string data;
        bool registered;
        uint dataCount;
    }

    constructor() public {
        clients[0xE53cA5Fa2Fc412F419dAb41418c536774F1e42a4].data = "age:22 name:khoa";
        clients[0xE53cA5Fa2Fc412F419dAb41418c536774F1e42a4].registered = true;
        clients[0xE53cA5Fa2Fc412F419dAb41418c536774F1e42a4].dataCount = 2;
    }

    function register() public {
        require(!clients[msg.sender].registered, "Already registered");
        clients[msg.sender].registered = true;
        clientsCount++;
    }

    function addData(string memory value) public hasRegistered() {
        clients[msg.sender].data = (clients[msg.sender].dataCount > 0) ? string(abi.encodePacked(clients[msg.sender].data, ' ', value)) : value;
        clients[msg.sender].dataCount++;
    }

    function sendData(address service) public hasRegistered() returns(bool) {
        (bool success, bytes memory result) = service.call(abi.encodeWithSignature("setData(address,string)", msg.sender, clients[msg.sender].data));
        return success;
    }

    //function test(address addr) public returns(string memory, uint) {
        //(bool success, bytes memory result) = dnsServices.call(abi.encodeWithSignature("serviceProviders(address)", addr));
        //return abi.decode(result, (string, uint));
    //}

    modifier hasRegistered() {
        require(clients[msg.sender].registered, "Not register");
        _;
    }

    //modifier contains(string memory what, string memory where) {
        //bytes memory whatBytes = bytes (what);
        //bytes memory whereBytes = bytes (where);

        //bool found = false;
        //for (uint i = 0; i < whereBytes.length - whatBytes.length; i++) {
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
        //require (found);

        //_;
    //}
}
