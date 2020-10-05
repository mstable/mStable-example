//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.16;

import { IMasset } from "@mstable/protocol/contracts/interfaces/IMasset.sol";
import { ISavingsContract } from "@mstable/protocol/contracts/interfaces/ISavingsContract.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 }  from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

contract MStable {
    using SafeERC20 for IERC20;
    address public massetContract;
    address public savingsContract;

    constructor(
        address _massetContract,
        address _savingsContract
    ) public {
        massetContract = _massetContract;
        savingsContract = _savingsContract;
    }

    function mint(
        address _bAsset,
        uint _bAssetQuanity
    ) external returns (uint256 massetMinted) {
        IERC20(_bAsset).safeApprove(massetContract, 0);
        IERC20(_bAsset).safeApprove(massetContract, uint256(-1));
        return IMasset(massetContract).mint(_bAsset, _bAssetQuanity);
    }

    function redeem(
        address _bAsset,
        uint _bAssetQuanity
    ) external returns (uint256 massetRedeemed) {
        return IMasset(massetContract).redeem(_bAsset, _bAssetQuanity);
    }

    function deposit(
        uint _amount
    ) external returns (uint256 creditIssued) {
        IERC20(massetContract).safeApprove(savingsContract, 0);
        IERC20(massetContract).safeApprove(savingsContract, uint256(-1));
        return ISavingsContract(savingsContract).depositSavings(_amount);
    }

    function withdraw(
        uint _amount
    ) external returns (uint256 massetReturned) {
        return ISavingsContract(savingsContract).redeem(_amount);
    }
}
