pragma solidity ^0.5.0;

import './lib/rsaverify.sol';
import './lib/verifier.sol';

contract Beerclub {
    using Pairing for *;
    using rsaverify for *;

    address constant idpContract = 0xdAfC8792D826958934C46ae25f4c6D96fc14C1C8;
    address constant dnsContract = 0x6B1AAF4285E519c1ca2180a39693ac6807029E70;
    
    address private owner;
    string private ipfsHash;
    mapping(address => bool) private authenticated;

    constructor() public {
        owner = msg.sender;
        ipfsHash = 'QmZVatmY6ZkBXzCtfATeUwGnK983Xku8fk9Lp2Ja3A4kQ7';
    }

    function isAuthenticated() public view returns(bool) {
        return authenticated[msg.sender];
    }

    function getIpfsHash() public view returns(string memory) {
        return ipfsHash;
    }

    function setIpfsHash(string memory _ipfsHash) public onlyOwner () {
        ipfsHash = _ipfsHash;
    }

    function getHashAndSignature(address addr) private returns(bytes memory, bytes memory) {
        (bool success, bytes memory result) = idpContract.call(abi.encodeWithSignature("getData(address,string)", addr, 'age'));
        require(success, "Cannot access IDP contract");
        return abi.decode(result, (bytes, bytes));
    }

    function getModulusAndExponent() private returns(bytes memory, bytes memory) {
        (bool success, bytes memory result) = dnsContract.call(abi.encodeWithSignature("getPublicKey(string)", 'age'));
        require(success, "Cannot access DNS contract");
        return abi.decode(result, (bytes, bytes));
    }

    function authenticate(uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[3] memory input) public {
        require(!authenticated[msg.sender], "You have been already authenticated");
        bytes memory inputHash = toBytes(input[0] * 340282366920938463463374607431768211456 + input[1]);
        (bytes memory hash, bytes memory signature) = getHashAndSignature(msg.sender);
        require(keccak256(inputHash) == keccak256(hash), "Hash value in proof.json is diffrent from hash value in the ledger");
        (bytes memory modulus, bytes memory exponent) = getModulusAndExponent();
        bytes32 hash32 = bytesToBytes32(hash, 0);
        require(hash32.pkcs1Sha256Verify(signature, exponent, modulus) == 0, "Signature error");
        require(verifyTx(a, b, c, input), "Invalid proof.json");
        authenticated[msg.sender] = true;
    }

    function toBytes(uint x) private pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
    
    function bytesToBytes32(bytes memory b, uint offset) private pure returns (bytes32) {
        bytes32 out;
    
        for (uint i = 0; i < 32; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
        }
        return out;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    struct VerifyingKey {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x05d887c8266ae0e0cc29f1f010d8c3b4d58e0d7c1e116edd48e518bfa7b5a4e9), uint256(0x0f83e472862e26dfb603e021f9948f33f847194a9573e521a953d764aeee4628));
        vk.b = Pairing.G2Point([uint256(0x01b10a8a1de60fc2072ad532f84d8cc0936296aeddd4ac5c0dce587cb8b6defb), uint256(0x0a488da88a52716fdcd14ab999af795ea318c2350442c6ba2048d4decf63959c)], [uint256(0x28d2ac6c8ec3d760673d6820280a28461edcebf06eb81e4f67852a62f99b3182), uint256(0x0925e0ff1a3ec4463e2e52a64326895dfe40a07cb6afa66d2187d789ffc97a73)]);
        vk.gamma = Pairing.G2Point([uint256(0x0c8df63f8e6321b6fadd355421ccf1e3798c1e21cb830ec40231205673acdf8c), uint256(0x14f50f1d0760f22b671ead74dc171cbda07f57340828f71e30b25397c8ddd809)], [uint256(0x085eb2bbad3f296dd17edf4f2bc6b5983a76ddef25aed6f9313b16e2bbfe9e5f), uint256(0x2047f54e9f5acfbd4c5ce73370b905631654ef27c476285b559b8e0b3bb640c9)]);
        vk.delta = Pairing.G2Point([uint256(0x23de7c1de870d94b4b6e57a05954fac4f7565c7ab4926af07af27e965783e22a), uint256(0x02921039a2c9cfdd5514745754f5584e4e36c41dcb7ba57406d6a31e0a559fbb)], [uint256(0x15835255b731107af89bc521f2a3f6dc1c244cec87b511a85a56a472adda25f1), uint256(0x0dc6a42c6e9c69a2f7d97ce3dd183b1c489019bb66a6b709fb540de8ece48c24)]);
        vk.gamma_abc = new Pairing.G1Point[](4);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x276e014efcc5b9e4b8454a0addcd28b1cb9c89f450975f4771e19faa32568b97), uint256(0x0d438c3722e6efa8b46d0ecda04f4e507ae45162f3e60f30ed4a9f3bfa739828));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x19183b214296735761ba95b50e2bbd71494b2793773d16ffed69bae9857d6138), uint256(0x2455697745c6927ab29dbcbb5224c2b8d8944285a5fd322a746ef1240c9261a2));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x1b72de1e189668a92998d78d4f618c7f15ff4c17db0d64c2d9e270dc2237e846), uint256(0x25970dcecf079eca63f293e69e2549dfad6f79b6de35c7fb32b49beeab549440));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x2726c99c753018c3b5293cc037bb62709fd2804bbe7b8f9951d9a4bdcad52375), uint256(0x2b5decdf5dc56a867e88bea3c88e8655c73e9f1fcb9670812672d7204dae8717));
    }
    function verify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
            proof.a, proof.b,
                Pairing.negate(vk_x), vk.gamma,
            Pairing.negate(proof.c), vk.delta,
            Pairing.negate(vk.a), vk.b)) return 1;
            return 0;
    }
    event Verified(string s);
    function verifyTx(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[3] memory input
    ) private returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
