// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "../libraries/Ownable.sol";
import "../libraries/Pausable.sol";

abstract contract OwnerPausable is Ownable, Pausable {
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
