# Integrating with mStable

This repo shows an example of integrating with the mStable protocol. The target network is Ropsten but this could be amended to target Mainnet.

An [introduction to the mStable][1] protocol is available that shows what mStable is and how you can use it.

By walking through this repo you'll be able to

- Write a basic smart contract that integrates with mStable
- Mint, deposit and redeem mUSD from your application

## Prerequsities

- Node.js v10.22.0 (you may wish to use [nvm][6])

## Installation

The mStable protocol contracts are available as an npm module that may be included in your projects.

### Using npm

    npm install @mstable/protocol --save-dev

### Using yarn

    yarn add @mstable/protocol --dev

### Why mStable?

mStable Assets (mAssets) are built to be the solid base layer in DeFi. The first mAsset, `mUSD`, comprises of `USDT`, `TUSD`, `DAI` and `USDC`. mAssets can be minted with any of the underlying and used as a trustworthy base layer with which to, for example, collateralise synthetic assets or loans. [Read more about mAssets](https://docs.mstable.org/mstable-assets/massets).

mAssets produce a native yield through the SAVE contract. Yield is derived from AMM swap trades and lending markets. Underlying assets can be redeemed at any time. mStable aims to be a foundational layer for DeFi applications.

#### Whats sort of stuff can be built?

Essentially anything that builds on top of or extends the mStable protocol, or simply utilises mAssets to their potential. We would also welcome any application utilising the system token MTA.

Some ideas to build on top of mStable:

- A no loss lottery (e.g. PoolTogether)
- A derivative using mStable SAVE or mUSD (e.g. CHAI)
- A derivative using mAssets as the settlement layer
- Deriving a yield for any application that accepts DAI, USDT, TUSD or USDC
- Utilising mStable MINT/SWAP as part of a trading bot
- An interest bearing stablecoin product for custodied stablecoins (e.g. a CEX)

Some ideas to utilise mAssets or MTA:

- Using mAssets to collateralise synthetic instruments
- An application that uses mUSD as collateral
- An application that uses MTA as collateral
- An index fund using MTA or mStable, where the SAVE product contributes to the yield

### Integrating mStable

Have a look at the `PoolWithMStable` contract for an example on how to integrate the mStable protocol. This represents a basic integration and more advanced developers may wish to go straight to the [contract documentation][4] or the [smart contracts on Github][5].

Note that the mStable contracts are compiled against `0.5.16` of solidity.

### Minting mUSD

mAssets represent a basket of underlying bAssets and that be minted using any of the bAssets that make up the basket. Developers may mint mAssets using a single bAsset or a combination of more than one.

See example [here][7]

### Interacting with SAVE

mAssets (e.g. mUSD) may be deposited into the relevant SAVE contract to earn a yield. Once deposited, mAsset is held on the SAVE contract but may be redeemed at any time. Balances are represented internally through credits, but these do not have an ERC20 token attached.

See deposit example [here][8] and withdraw [here][9]

### Redeeming from mUSD

An mAsset can be redeemed for any one of its underlying bAssets, providing that:

- the bAsset being redeemed has sufficient liquidity
- redeeming the bAsset does not push another bAsset beyond its maximum weight

See example [here][10]

[1]: https://docs.mstable.org/developers/introduction
[2]: https://docs.mstable.org/mstable-assets/massets
[3]: https://docs.mstable.org/protocol/security#auditing
[4]: https://docs.mstable.org/developers/developers
[5]: https://github.com/mstable/mStable-contracts
[6]: https://github.com/nvm-sh/nvm
[7]: https://docs.mstable.org/developers/integrating-mstable#minting-musd
[8]: https://docs.mstable.org/developers/integrating-mstable#depositing-into-save
[9]: https://docs.mstable.org/developers/integrating-mstable#withdrawing-from-save
[10]: https://docs.mstable.org/developers/integrating-mstable#redeeming-from-musd
