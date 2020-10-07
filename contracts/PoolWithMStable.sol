pragma solidity 0.5.16;

import { IMasset } from "@mstable/protocol/contracts/interfaces/IMasset.sol";
import { IMStableHelper } from "@mstable/protocol/contracts/interfaces/IMStableHelper.sol";
import { ISavingsContract } from "@mstable/protocol/contracts/interfaces/ISavingsContract.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 }  from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import { Ownable }  from "@openzeppelin/contracts/ownership/Ownable.sol";

// Allows participants to stake mUSD and have the
// interest from SAVE be distributed to a specified beneficiary
contract PoolWithMStable is Ownable {

    using SafeERC20 for IERC20;

    IERC20 public mUSD;
    ISavingsContract public save;
    IMStableHelper public helper;

    mapping(address => uint256) public gifts;
    uint256 totalGifts = 0;

    event GiftStaked(address indexed staker, uint256 amount);
    event GiftWithdrawn(address indexed staker, uint256 amount);
    event InterestCollected(uint256 amount);

    constructor(
        IERC20 _mUSD,
        ISavingsContract _save,
        IMStableHelper _helper,
        address _beneficiary
    )
        public
        Ownable()
    {
        mUSD = _mUSD;
        save = _save;
        helper = _helper;

        _transferOwnership(_beneficiary);

        mUSD.safeApprove(address(save), uint256(-1));
    }

    // Stake an amount of mUSD and deposit into SAVE
    function stakeGift(
        uint256 _amount
    )
        external
    {
        // Either we are depositing mUSD or we can mint as follows
        // IMasset(_mUSD).mint(<bAsset>, <bAssetQuanity>);

        mUSD.safeTransferFrom(msg.sender, address(this), _amount);

        save.depositSavings(_amount);

        gifts[msg.sender] += _amount;
        totalGifts += _amount;

        emit GiftStaked(msg.sender, _amount);
    }

    // Withdraw the staked mUSD
    function withdrawGift(
        uint256 _amount
    )
        external
    {
        uint256 giftBalance = gifts[msg.sender];

        require(_amount <= giftBalance, "Not enough balance");

        gifts[msg.sender] -= _amount;
        totalGifts -= _amount;

        uint256 creditsToRedeem = helper.getSaveRedeemInput(save, _amount);
        save.redeem(creditsToRedeem);

        // Either we return the mUSD or we could redeem into something
        // bAsset = helper.getRedeemBasset();
        // IMasset(mUSD).redeem(<bAsset>, <bAssetQuanity>);

        mUSD.transfer(msg.sender, _amount);

        emit GiftWithdrawn(msg.sender, _amount);
    }

    // Distribute any of the accrued interest to the beneficiary
    function collectInterest() external {
        uint256 currentBalance = helper.getSaveBalance(save, address(this));
        uint256 delta = currentBalance - totalGifts;

        uint256 creditsToRedeem = helper.getSaveRedeemInput(save, delta);
        save.redeem(creditsToRedeem);

        mUSD.transfer(owner(), delta);

        emit InterestCollected(delta);
    }
}
