// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "../libraries/ERC20Burnable.sol";
import "../libraries/Ownable.sol";
import "../interfaces/IRequiemStableSwap.sol";

contract LPToken is Ownable, ERC20Burnable {
    IRequiemStableSwap public swap;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        swap = IRequiemStableSwap(msg.sender);
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        require(_amount > 0, "zeroMintAmount");
        _mint(_to, _amount);
    }

    /**
     * @dev Overrides ERC20._beforeTokenTransfer() which get called on every transfers including
     * minting and burning. This ensures that swap.updateUserWithdrawFees are called everytime.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        super._beforeTokenTransfer(from, to, amount);
        swap.updateUserWithdrawFee(to, amount);
    }
}
