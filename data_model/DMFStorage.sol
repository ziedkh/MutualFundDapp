pragma solidity ^0.4.23;
import "../controller/proxy.sol";


contract DMFStorage {
 
       
   proxy p = proxy (address(0xB955dCa9a813c317d4e6F9412F52f244d86767EE));
 
   bytes32 contractHash = p.init("DMFStorage",address(this));
       
        uint256  InvestorsTotalToken=0; //investor total token count
        uint256 public commission;
        address public amc_contractAddress;
        address public newadd;
        uint256 public numerator_Registration = 0;
        uint256 public  denominator_Registration = 1;
        address public AMC_Owner;
 
        address[] public  MF_contractAddresses;
        address[] public ToatlportfolioMAddress; //Array for storing the each register PortfolioManager
        address[] public TotalInvestorAddress; //Array for storing the each register Investors
        //address public TokenInterface;
        address[] public ToatlportfolioMA_Tokens;
 
        //Structure For PortfolioManager Details
        struct PortfolioDetails
        {
            address manager;
            address contractAddress;
            uint256 totalsupply;
            uint256 NAV;
            uint256 purchaseFee;
            uint256 withdrawFee;
            uint256 numerator ;
            uint256 denominator ;
            address[] investorAddressForPortfolio;
            uint commissionForPortfolio;
        }
        //Structure For Investor Details
        struct InvestorDetails
        {
            address[] PortfolioHolders; // mutual fund tokens invested in
            uint256 eth;
            uint256 TokenCount;
        }

        //Mapping Area
        mapping(address => address) public MF_Token_holders;
        //Map for getting and storing the PortfolioManager resgistration Details
        mapping(address => PortfolioDetails) public Portfolio;
        //map for getting and storing the Investor getting token details
        mapping(address=> InvestorDetails) public Investment;    // investor=> details
        mapping(address => mapping( address =>  InvestorDetails)) public investor;  //mutualfund => (investor => details)
}

