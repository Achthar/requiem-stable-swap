// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "./IERC20.sol";

interface IMiniChefV2 {
    function lpToken(uint256 _pid) external view returns (IERC20);
}
