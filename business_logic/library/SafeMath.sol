pragma solidity ^0.4.23;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a,'must require c >= a');
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a,'must require b <= a');
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b,'must require a == 0 or c / a == b');
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0,'must require b > 0');
        c = a / b;
    }
}
