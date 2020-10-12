pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,
        address payable wallet,
        PupperCoin token,
        uint goal,
        uint open,
        uint close,
        uint cap
    )
        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        CappedCrowdsale(cap)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
        public
    {
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal,
        uint cap
    )
        public
    {
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_sale_address = address(token);

        PupperCoinSale pupper_coin_sale = new PupperCoinSale(1, wallet, token, goal, now, (now + 5 minutes), cap);
        token_sale_address = address(pupper_coin_sale);

        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
    
}
