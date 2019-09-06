pragma solidity ^0.4.23;

contract FundTokenStorage{
 
    string standard="Token 1.0";
    string public name;
    string public symbol;
    uint256 public totalsupply;
    uint256  initialallowed;
    uint256 public decimals;
    address Owner;

    mapping(address=>uint) public balanceOf;
    mapping(address=>mapping(address=>uint256))public allowed;
}
