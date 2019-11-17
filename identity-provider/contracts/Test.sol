pragma solidity ^0.5.0;

contract Test {
    string memeHash;

    // Write function
    function set(string memory _memeHash) public {
        memeHash = _memeHash;
    }

    // Read function
    function get() public view returns(string memory) {
        return memeHash;
    }

}
