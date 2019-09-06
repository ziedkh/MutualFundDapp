pragma solidity ^0.4.23;
import "../controller/proxy.sol";
import "./library/SafeMath.sol";
import "../data_model/DMFStorage.sol";
import "./FundToken.sol";

contract DMF is DMFStorage{

    proxy p = proxy(address(0xB955dCa9a813c317d4e6F9412F52f244d86767EE));
    bytes32 contractHash = p.init("DMF",address(this));
    using SafeMath for uint256;

//___________________________________________Event & modifier _________________________________________________________________________________

    event AMC_Commission(uint256 commission);

    event Portfolio_Details(address manager,address contractAddress,
                            uint256 totalsupply, uint256 NAV,uint256 purchaseFee,
                            uint256 withdrawFee,uint256 numerator,uint256 denominator,
                            uint256 commissionForPortfolio);
                        
    
    event MFtokenGenerated(address owner,string symbol,string  name,uint256 decimals,address tokenContract);

    event PriceUpdate( address MutualFundToken, uint256 numerator, uint256 denominator);

    event NavUpdate( address MutualFundToken ,uint256 current, uint256 _new);

    event ResgistrationFeeUpdated(uint256 numerator_Registration,uint256 denominator_Registration);

    event Resgistration(uint256 numerator_Registration, uint256 denominator_Registration);

    event NewMutualFund( address MutualFundToken, uint256 purchaseFee ,uint256 withdrawFee, uint256 numerator,uint256 denominator);

    event MutuadFundShare( address MutualFundToken ,uint256 _NAVPS);

    event GetToken(address investor, address MutualFundToken ,uint256 share_nbr);

    event ReturnToken(address investor, address MutualFundToken ,uint256 share_nbr);

    event PurchaseFeeShare( address _mf_token_address, uint256  _purchaseFee_share);

    event WithdrawFeeShare(address _mf_token_address, uint256 _purchaseFee_share);

    event alreadyManager(address alreadymanager);

    event _values(uint256 Toatlportfolio, uint256 TotalInvestor);
        
    event _MFmanager(address manager);

    event _Investorcount(uint256 investorPortfoliolength) ;

    event _portfoliocount(uint256 portfoliocount);
        
    event _InvestorList (address investor);
        
    event _PortfolioList(address PortfolioHolder);
    
    event _GetFundToken_supply(uint256 supply);

    event is_manager(bool user_status);

    event InvestorPortfolio_Details(uint256 eth,uint256 TokenCount);

//____________________ AMC CREATION and registrationFee management________________________________________

//Constructor For initialize the contract Owner Address and Contract Deployed Address
        constructor() public payable
        {
            newadd = address(this);
            AMC_Owner = msg.sender;
        }
//__________________________________________________ FundToken  GENERATOR___________________________________________________________________________

        function MF_Token_Generator(string symbol, string name, uint256 decimals) public payable {
        require(MF_Token_holders[msg.sender] == address(0),"you have already created one!!");
        if (MF_Token_holders[msg.sender] != address(0)){emit alreadyManager(msg.sender);}
          FundToken tokenContract = new FundToken(symbol, name,decimals,msg.sender);
          MF_contractAddresses.push(address(tokenContract));
          MF_Token_holders[msg.sender] = address(tokenContract);

          emit MFtokenGenerated(msg.sender,symbol,name,decimals,address(tokenContract));
        }

//____________________________________________Mutualfund CREATION and management______________________________
       function Taken_mf_token(address _mf_token_address) private view returns(bool){
           for(uint256 i = 0;i<ToatlportfolioMA_Tokens.length;i++){
                if( _mf_token_address == ToatlportfolioMA_Tokens[i]){
                    return true;
                }
           }
            return false;
        }

        function Portfolio_Mutual_fund_Reg( uint256 _purchaseFee, uint256 _withdrawFee, uint256 _numerator, uint256 _denominator) public payable
        {
            require(MF_Token_holders[msg.sender]!=address(0),"YOU HAVE to create MF_Token");
            address _mf_token_address = MF_Token_holders[msg.sender];
            require(Portfolio[msg.sender].contractAddress == address(0)," you are already a fund manager");
            require(!Taken_mf_token(_mf_token_address), " this token is already taken by another manager, create yours !!!");
            require (FundToken(address(_mf_token_address)).Token_Owner() == (msg.sender), " you are not the token owner !!!!" );
            uint256 value = msg.value.div(1 ether);
            /*____________________________________ AMC comission ____________________________*/
            uint256 Registration_amc_Fee = (value.mul(numerator_Registration)).div(denominator_Registration);
            commission = commission.add(Registration_amc_Fee).mul(1000); //to get the real result .div(1000)
            
            /*____________________________________ Mf param__________________________________*/
            
            uint256 net_value = value.sub(Registration_amc_Fee);
            
            Portfolio[msg.sender].NAV = Portfolio[msg.sender].NAV.add(net_value).mul(1000);
            Portfolio[msg.sender].manager = msg.sender;
            Portfolio[msg.sender].purchaseFee = _purchaseFee;
            Portfolio[msg.sender].withdrawFee = _withdrawFee;
            Portfolio[msg.sender].numerator = _numerator;
            Portfolio[msg.sender].denominator = _denominator;
 
            uint256 tokens = GetFundToken(Portfolio[msg.sender].NAV.div(1000),msg.sender,_mf_token_address);
        
            Portfolio[msg.sender].totalsupply = Portfolio[msg.sender].totalsupply.add(tokens);
            
            ToatlportfolioMAddress.push(msg.sender);
            Portfolio[msg.sender].contractAddress = _mf_token_address;
            ToatlportfolioMA_Tokens.push(_mf_token_address);
       
            emit NewMutualFund(_mf_token_address,_purchaseFee,_withdrawFee,_numerator,_denominator);
        
        }
        /*Function For Getting the Fundtokens by the PortfolioManager only for the first time  there is no fees for manager*/
        function GetFundToken(uint256 value, address _manager, address _mf_token_address) private returns(uint256)
        {   
            require(Portfolio[_manager].contractAddress == address(0));
            uint256 tokens = value.mul(Portfolio[_manager].numerator).div(Portfolio[_manager].denominator);
            // 1 ether => 100 token
            FundToken(_mf_token_address).mintToken(_manager,tokens);
            return(tokens);
        }
         
        function Get_MutualFundPortfolio(address _manager)public
        {
        PortfolioDetails storage _Portfolio = Portfolio[_manager];

        emit Portfolio_Details(_Portfolio.manager,_Portfolio.contractAddress,_Portfolio.totalsupply, _Portfolio.NAV,_Portfolio.purchaseFee,
            _Portfolio.withdrawFee,_Portfolio.numerator,_Portfolio.denominator,_Portfolio.commissionForPortfolio);
        }
       
       function updateNAV(bool _action ) public payable 
       {
           address _mf_token_address = Portfolio[msg.sender].contractAddress;
           require(Portfolio[msg.sender].contractAddress == _mf_token_address,"only mf owner");
           require(msg.sender == FundToken(_mf_token_address).Token_Owner());
           // case where mf oOwnershipTransferred
           require (_action == true || _action == false,"action should be true or false");
            //1:up 2:down

           //uint256 _value= msg.value.div(1 ether);

            uint256 current = Portfolio[msg.sender].NAV;
            if(_action){
            Portfolio[msg.sender].NAV = Portfolio[msg.sender].NAV.add(msg.value.div(1 ether)).mul(1000);
           }
           else
           {
           // require(Portfolio[msg.sender].NAV.sub(msg.value).div(1 ether ) > 0);
            Portfolio[msg.sender].NAV = Portfolio[msg.sender].NAV.sub(msg.value.div(1 ether)).mul(1000);
           }
            uint256 _new = Portfolio[msg.sender].NAV;
            //IF update <0 => call divended function :give back all investors investment and annonuce it to the AMC owner
           emit NavUpdate(_mf_token_address, current,_new);
        }



//____________________________________________Investor registration  and operations _______________________________________________________________________________

         function Get_Investor_Portfolio(address _investor)public
        {
        InvestorDetails storage _Portfolio = Investment[_investor];

        emit InvestorPortfolio_Details(_Portfolio.eth,_Portfolio.TokenCount);
        }

        function InvestorGetToken(address manager_address, uint256 shares_nbr) public payable
        {
            
            address _mf_token_address = Portfolio[manager_address].contractAddress;
            uint256 MF_value = shares_nbr.mul(Mutual_fund_share(manager_address));
            uint256 Fee_value = shares_nbr.mul(Purchase_fee_per_share(manager_address));
            uint256 value = MF_value.add(Fee_value);
            require(msg.value!=0 && value <= msg.value.mul(1000),"insuffissant ether amout");
            FundToken(_mf_token_address).mintToken(msg.sender,shares_nbr);
            if(!is_investor(_mf_token_address,manager_address)){
                TotalInvestorAddress.push(msg.sender);
                Portfolio[manager_address].investorAddressForPortfolio.push(msg.sender);
                Investment[msg.sender].PortfolioHolders.push(_mf_token_address);
                Investment[msg.sender].eth = Investment[msg.sender].eth.add(msg.value.div(1 ether)).mul(1000);
            }
            InvestorsTotalToken = InvestorsTotalToken.add(shares_nbr);

            // investor account in the AMC
            Investment[msg.sender].eth = Investment [msg.sender].eth.sub(value);
            Investment[msg.sender].TokenCount = Investment [msg.sender].TokenCount.add(shares_nbr);
            
            // investor account in the mf
            investor[FundToken(_mf_token_address)][msg.sender].eth = investor[FundToken(_mf_token_address)][msg.sender].eth.add(MF_value);
            // to compare the value after NAV update
            investor[FundToken(_mf_token_address)][msg.sender].TokenCount = investor[FundToken(_mf_token_address)][msg.sender].TokenCount
                                                                            .add(shares_nbr);
            Portfolio[manager_address].NAV = Portfolio[manager_address].NAV.add(MF_value);
            Portfolio[manager_address].totalsupply = Portfolio[manager_address].totalsupply.add(shares_nbr);
            Portfolio[manager_address].commissionForPortfolio = Portfolio[manager_address].commissionForPortfolio.add(Fee_value).mul(1000);
            
            emit GetToken(msg.sender,_mf_token_address,shares_nbr);
            // check value before
        }
        function InvestorReturnToken(address manager_address, uint256 shares_nbr ) public  payable
        {   address _mf_token_address = Portfolio[manager_address].contractAddress;
            require(Investment[msg.sender].TokenCount >= shares_nbr,"insuffissant tokens "); //already done by the ERC20
            FundToken(_mf_token_address).burnToken(msg.sender,shares_nbr);
            
            uint256 MF_value = shares_nbr.mul(Mutual_fund_share(manager_address));
            uint256 Fee_value = shares_nbr.mul(Withdraw_fee_per_share(manager_address));
            uint256 value = MF_value.sub(Fee_value);
            
            InvestorsTotalToken = InvestorsTotalToken.sub(shares_nbr);
            // investor account in the AMC
            Investment[msg.sender].eth = Investment [msg.sender].eth.add(value);
            Investment[msg.sender].TokenCount = Investment [msg.sender].TokenCount.sub(shares_nbr);
            // investor account in the mf
            investor[FundToken(_mf_token_address)][msg.sender].eth = investor[FundToken(_mf_token_address)][msg.sender].eth.sub(MF_value);
            // to compare the value after NAV update
            investor[FundToken(_mf_token_address)][msg.sender].TokenCount = investor[FundToken(_mf_token_address)][msg.sender].TokenCount
                                                                            .sub(shares_nbr);
            Portfolio[FundToken(_mf_token_address).Token_Owner()].NAV = Portfolio[FundToken(_mf_token_address).Token_Owner()].NAV.sub(MF_value);
            Portfolio[manager_address].totalsupply = Portfolio[manager_address].totalsupply.sub(shares_nbr);
            Portfolio[manager_address].commissionForPortfolio = Portfolio[manager_address].commissionForPortfolio.add(Fee_value);
             emit ReturnToken(msg.sender,_mf_token_address,shares_nbr);
        }
        function transfertoken(address _mf_token_address,address _to, uint _amt) public payable  {
        FundToken(_mf_token_address).transferToken_(msg.sender,_to,_amt);
        }

        function transferEther(address _to) public payable {
         //require(_to != address(0) && _to!= msg.sender);
          //require(_amount <= Portfolio[FundToken(_mf_token_address).Token_Owner()].max_withdraw);
          //require(investor[FundToken(_mf_token_address)][msg.sender].eth >= _amount);
         address(_to).transfer(msg.value);}

//__________________________________________________ Helper__________________________________________________________________________
       
        function Mutual_fund_share(address manager_address) public payable returns (uint256){
            require(Portfolio[manager_address].totalsupply != 0,"should_has_shares");
            address _mf_token_address = Portfolio[manager_address].contractAddress;
           // require(Taken_mf_token(_mf_token_address), "Invalid Mf token");
            uint256 _nav = Portfolio[manager_address].NAV;
            uint256 _totalsupply = Portfolio[manager_address].totalsupply;
            uint256 _NAVPS = _nav.div(_totalsupply);
            emit  MutuadFundShare(_mf_token_address, _NAVPS);
            return(_NAVPS); //front div1000
       }
        function Purchase_fee_per_share(address manager_address) public payable returns(uint256){
           address _mf_token_address = Portfolio[manager_address].contractAddress;
           uint256 _NAVPS = Mutual_fund_share(manager_address);
           uint256 _purchaseFee = Portfolio[manager_address].purchaseFee;
           uint256 _purchaseFee_share = _NAVPS.mul(_purchaseFee).div(100);
           emit PurchaseFeeShare(_mf_token_address, _purchaseFee_share);
           return (_purchaseFee_share);
       }
       function Withdraw_fee_per_share(address manager_address) public payable returns(uint256){
          
            address _mf_token_address = Portfolio[manager_address].contractAddress;
           uint256 _NAVPS = Mutual_fund_share(manager_address);
           uint256 _withdrawFee = Portfolio[manager_address].withdrawFee;
           uint256 _withdrawFee_share = _NAVPS.mul(_withdrawFee).div(100);
           emit WithdrawFeeShare(_mf_token_address, _withdrawFee_share);
           return(_withdrawFee_share);
           }
       function is_investor(address _mf_token_address,address manager_address) private view returns(bool){
          for(uint256 i = 0 ;i<TotalInvestorAddress.length;i++){
                if( _mf_token_address == Portfolio[manager_address].investorAddressForPortfolio[i]){
                    return true;
                }
           }
            return false;
        }
        function values() public payable{
            emit _values(ToatlportfolioMAddress.length,TotalInvestorAddress.length);
        }
       function MFmanager(uint256 index) public payable returns(address){
            return(address(ToatlportfolioMAddress[index.sub(1)]));
        }
        function Investorcount(address a) public payable {
            emit  _Investorcount(Portfolio[a].investorAddressForPortfolio.length);
        }
        function  portfoliocount(address a) public payable{
            emit _portfoliocount(Investment[a].PortfolioHolders.length);
        }
       function InvestorList(address a,uint256 i)public payable {
           emit _InvestorList(Portfolio[a].investorAddressForPortfolio[i]);
        }
        function PortfolioList(address a,uint256 i)public payable{
           emit _PortfolioList(Investment[a].PortfolioHolders[i]);
        }
        function UserStatus()public payable{
            for(uint256 i = 0 ;i<ToatlportfolioMAddress.length;i++){
                if( msg.sender == ToatlportfolioMAddress[i]){
                    emit is_manager(true);
                }
           }
           emit is_manager(false);
            
        }
        // to get the real value of nav or eth .div(1000)
}
