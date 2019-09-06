pragma solidity ^0.4.23;
import "./token/ERC20.sol";
import "./library/SafeMath.sol";
import "../data_model/FundTokenStorage.sol";

contract FundToken is FundTokenStorage , ERC20{
    
   using SafeMath for uint256;
    
   constructor( string _mf_token_address, string _name , uint256 _decimals,address _owner) public
    {
        totalsupply=0;
        balanceOf[_owner]=totalsupply;
        symbol=_mf_token_address;
        name=_name;
       // initialallowed=500;
        decimals= _decimals;
        Owner = _owner;
        
    }
    function transferFrom(address from, address to, uint256 value)public returns(bool) 
    {
        balanceOf[from]=balanceOf[from]-value;
        balanceOf[to] =balanceOf[to]+value;
       emit Transfer(from,to,value);
        return true;
    }

       function transferToken_(address _from , address to, uint value) public
    {
        require(value<=balanceOf[_from]);
        
        balanceOf[_from]=balanceOf[_from].sub(value);
        balanceOf[to]=balanceOf[to].add(value);
       //emit Transfer(msg.sender,to,value);
       
    }
    function totalSupply() public view returns (uint256)
    {
       return totalsupply;
    }
    function getBalanceOf(address _addr) public view returns (uint256)
    {
        return balanceOf[_addr];
    }
    
    function mintToken(address _add_,uint256 _amo) public
    {
        totalsupply = totalsupply + _amo;
        balanceOf[_add_] = balanceOf[_add_] + _amo;
    }
    
    function burnToken(address _add_,uint256 _amo) public 
    {
        balanceOf[_add_] = balanceOf[_add_].sub(_amo);
        totalsupply=totalsupply.sub(_amo);
    }

    function Token_Owner() public view returns(address)
    {
        return Owner;
    }

}

