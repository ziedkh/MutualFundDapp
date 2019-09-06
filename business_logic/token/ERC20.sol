pragma solidity ^0.4.23;

contract ERC20 {
 
    function totalSupply() public constant returns (uint);
    function getBalanceOf(address tokenOwner) public constant returns (uint balance);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint token);
}
