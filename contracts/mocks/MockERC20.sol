// SPDX-License-Identifier: MIT

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../libraries/ERC20.sol";

/**
 * @dev THIS CONTRACT IS FOR TESTING PURPOSES ONLY.
 */
contract MockERC20 is ERC20 {
    uint8 internal decimals_;
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol) {
        super._mint(msg.sender, 1e27);
        decimals_ = _decimals;
    }

    function mint(address _receiver, uint256 _amount) external {
        _mint(_receiver, _amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return decimals_;
    }
}
