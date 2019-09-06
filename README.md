# MutualFundDapp
## **Mutual Fund**

Mutual fund is the best solution for small or individual investors, who search for a professionally
managed portfolio in order to get a trade-off between risk and return. Mutual fund pool investors money
into a fund managed by a fund manager, who invests in various assets like equities, stocks, bonds and
other securities. This gives investors an important diversification with a small investment. Mutual fund
investors get a part of ownership of the mutual fund company’s assets called share and participate
proportionally in the gains or losses of the fund.

## **Mutual Fund modus operandi**

Depending on the objective of the fund, the fund manager investment vary and may include
stocks, bonds, options, currencies, treasuries and money market securities. 
We notice that,the interaction between Mutual fund actors flow these steps:
1. Individual investors put their money into a fund pool,
2. A fund manager manage the fund portfolio,
3. Managers use their knowledge and experience to manage the portfolio and invest in different
securities depending on the fund objective,
4. Investment return will be generated to shareholders proportionally to their contribution.

## **Implementing Blockchain technology in Mutual Fund Ecosystem**

The centralized environment is one of the biggest challenges in the Mutual Fund industry, because of
the cost of maintaining digital infrastructure and uptimes. Further, The overall investing process is slow
and time consuming. For example, there is an important time lag from the closure of stock market for
the computation of Net Asset Value (abrev. NAV).
So, there is a crucial need to move from manual process of funds trading to a "FinTech" industry that uses
new technologies to automate the finance infrastructure. This Mutual Fund industry transformation have
to automate the global funds markets by improving the fund management, accelerate the transaction
cycle, increase transparency, ensure asset security and reduce management fees.
Blockchain have a direct impact on businesses, particularly on the financial services and banking.
Thus, the blockchain technology can improve the Mutual Fund industry with its decentralization,
transparency, tamper-resistance, privacy and accountability. All will allow to save time and cost of
transaction processing.
Smart contracts can be used to ensure that any update of information is available for all on the blockchain
and automate transaction processing. Multiple types of tokens can help us also for digital assets in the
Mutual Fund industry.

## **Proposed solution**
Blockchain technology offers the Mutual fund industry an opportunity to implement innovative man-
agement approach.Typically, Fund managers use a third party to record the shareholders and realize
complex identification process such as Know Your Customer(abrev. KYC) and Anti Money Launder-
ing(abrev. AML), which makes it difficult to manage a large number of shareholders. while blockchain
technology simplifies all this process because of its immutable, permanent and independent ledger, as
well as the use of smart contracts to automate complex process and adding more effective features such
as decentralized management through a Decentralized Autonomous Organization(abrev. DAO) betweenthe investors and their fund managers. Instead of using traditional asset management in which assets
are administrated separately, tokenized assets can be used in the mutual fund industry in order to make
all the assets accessible and efficiently managed by any mutual fund manger from one only account.
This will simplify and reduce the cost of the asset management and maximize investors’ returns.

 
## **selected Platform**
After studying the various types of mutual funds and the different blockchain platforms. we need to
select a mutual fund type and a blockchain platform that fits our project’s requirements,
• Investors have to interact directly with their funds.
• We need Private blockchain to test our solution and then Public blockchain to publish it.
• Our business logic should be automated via Smart contracts.
• The support of Crypto-currencies in order to transfer crypto-assets.
• Well documentation is needed to understand the development technique of our project.
In order to respect all these criteria, we have selected the open-end fund investment and the Ethereum
blockchain to develop our own proof of concept of implementing the blockchain technology in the
mutual fund system.


## **System architecture**
Our system must provide a marge of extensibility and scalability for each component. In order to respect
these requirements, we choose to follow a modular aspect.
before going into the details of the system design phase, it is essential to present the architecture that
encompasses the previous chapter’s needs. This architecture as illustrated in Figure 5.1 is essentially
composed of two parts :

### • Front-end 

This part contains the different interfaces with which the users can interact. These
interfaces are developed with Angular7 and other web technologies.
In order to invoke Ethereum network API, we have to use client libraries such as web3.js and connect
to an Ethereum node. We may run nodes ourselves or connect to existing one via bridge/proxy
using browser plugin such as Metamask.

## • Smart Contract 

This is the crucial part for our decentralized application which provides
communication with the Blockchain network in order to benefit from the blockchain revolutionary
feature of no single point of failure/truth. Thus, we no longer need for any "server" to run as a
back-end and secure our application against tampering, which can fail and make our application
unavailable. So, once our smart contracts are deployed they will run on the blockchain. Notice that
the decentralized consensus used by distributed network of participants is secure by design since
no data modification could happen without the global agreement. The smart contract, running in
the Ethereum network,
– Must be written using a turing-complete language like Solidity and then deployed to the
network.
– Miners have to run their Ethereum Virtual Machines and handle contract API calls.













