# Integrating with mStable

This repo shows an example of integrating with the mStable protocol. The target network is Ropsten but this could be amended to target Mainnet.

An [introduction to the mStable][1] protocol is available that shows what mStable is and how you can use it. 

By walking through this repo you'll be able to 

* Write a basic smart contract that integrates with mStable
* Deploy the contract to Ropsten
* Mint, deposit and redeem mUSD from your application

## Prerequsities

* Node.js  

## Installation

### Using npm

    npm install @mstable/protocol --save-dev 

### Using yarn

    yarn add @mstable/protocol --dev

This will make the contracts that make up the mStable protocol available to your application. 

### Why mStable?

If your application uses USDT, USDC, TUSD or DAI you can use mStable to earn a
yield on your stablecoins. Contracts that hold stablecoins can earn a yield for
end users rather than simply leave them on the contract. mUSD represents a
basket of underlying stablecoins that are collateralised by MTA. You can read
more about how the protocol works [here][2]. By using mStable applications can
offer users a yield on stablecoins and an additional safety mechanism that the
basket is collateralised by MTA. Note that although the contracts have [been
indepently audited][3] there is still risk in using mStable.

Some potential applications that can be created using the mStable protocol are

* Deriving a yield for any application that accepts DAI, USDT, TUSD or USDC
* A no loss lottery
* An arbitrage bot that builds on top of SWAP
* A derivative using mStable SAVE or mUSD
* A wrapper to allow any stablecoin to mint mUSD
* A wrapper to allow any ERC-20 to mint mUSD
* An application that uses mUSD as collateral
* An application that uses MTA as collateral
* An index fund using MTA or mStable, where the SAVE product contributes to the yield
* An interest bearing stablecoin product for custodied stablecoins (e.g. a CEX). 

### Integrating mStable

In this example you will learn how to integrate the mStable protocol. This represents a basic integration and more advanced developers may wish to go straight to the [contract documentation][4] or the [smart contracts on Github][5]. 

Note that the mStable contracts are compiled against `0.5.16` of solidity.

First include the `IMasset` interface so we can mint mUSD. 

### Minting

Minting takes one or more of the supported tokens and issues mUSD. The following is an example that shows how you can add minting mUSD to a smart contract. Note that this assumes there are some supported stablecoin tokens held on the contract. 

```
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.16;

import { IMasset } from "@mstable/protocol/contracts/interfaces/IMasset.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 }  from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

contract MStable {
    using SafeERC20 for IERC20;
    address public massetContract;

    constructor(address _massetContract) public {
        massetContract = _massetContract;
    }

    function mint(
            address _bAsset,
            uint _bAssetQuanity
            ) external returns (uint massetMinted) {
        IERC20(_bAsset).safeApprove(massetContract, 0);
        IERC20(_bAsset).safeApprove(massetContract, uint256(-1));
        return IMasset(massetContract).mint(_bAsset, _bAssetQuanity);
    }
}

```

[1]: https://docs.mstable.org/developers/introduction
[2]: https://docs.mstable.org/mstable-assets/massets
[3]: https://docs.mstable.org/protocol/security#auditing
[4]: https://docs.mstable.org/developers/developers
[5]: https://github.com/mstable/mStable-contracts
