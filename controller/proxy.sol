pragma solidity ^0.4.23;


contract proxy {
    mapping(bytes32 => address) currentVersion;
    mapping(bytes32 => address) owner;
    
      
    bytes32 h =  init("proxy",address(this));
    
    modifier onlyOwner(string memory contractName) {
        bytes32 contractHash = keccak256(abi.encodePacked(contractName));
        require(msg.sender == owner[contractHash]);
        _;
    }
   
    function init(string memory contractName , address initAddr) public returns (bytes32){
        bytes32 contractHash = keccak256(abi.encodePacked(contractName));
        currentVersion[contractHash] = initAddr;
        owner[contractHash] = msg.sender; 
        return contractHash;
    }

    function changeContract(string memory contractName,address newVersion) public
    onlyOwner(contractName)
    {
        bytes32 contractHash = keccak256(abi.encodePacked(contractName));
        currentVersion[contractHash] = newVersion;
    }
    
    function changeOwner(string memory contractName ,address newOwner) public
    onlyOwner(contractName)
    {
        bytes32 contractHash = keccak256(abi.encodePacked(contractName));
        owner[contractHash] = newOwner;
    }
    
    function getCurrentVersion(string memory contractName) public view returns (address) {
        bytes32 contractHash = keccak256(abi.encodePacked(contractName));
        return currentVersion[contractHash];
    }
    
    function getOwner(string memory contractName) public view returns (address) {
         bytes32 contractHash = keccak256(abi.encodePacked(contractName));
         return owner[contractHash];
    }
    
    
}
