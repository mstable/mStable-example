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
