// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./libraries/Initializable.sol";
import "./libraries/Ownable.sol";
import "./interfaces/IERC20.sol";
import "./libraries/SafeERC20.sol";
import "./interfaces/IRequiemStableSwap.sol";
import "./RequiemStableSwapRouter.sol";

contract FeeDistributor is Initializable, Ownable {
    using SafeERC20 for IERC20;

    enum SwapPoolType {
        plain,
        meta
    }

    struct SwapConfig {
        SwapPoolType poolType;
        address pool;
        address basePool;
    }

    /// @dev convert all fee to this token
    address public target;

    /// @dev fromToken => routerAddress
    mapping(address => SwapConfig) public getSwapConfig;
    mapping(address => bool) public operators;

    RequiemStableSwapRouter public swapRouter;
    address[] public whiteListedTokens;
    uint256 constant swapTimeout = 3600;

    /* ========== PUBLIC FUNCTIONS ========== */

    function transfer(IERC20 token, address to, uint256 amount) external {
        if (operators[msg.sender] == true) {
            uint256 _before = token.balanceOf(address(this));
            if (_before >= amount) {
                token.safeTransfer(to, amount);
                uint256 _after = token.balanceOf(address(this));
                require(_before - _after == amount, 'transfer-fail');
                emit TransferFee(msg.sender, to, token, amount);
            }
        }
    }

    function swap() external {
        if (operators[msg.sender] == true) {
            for (uint256 i = 0; i < whiteListedTokens.length; i++) {
                address fromToken = whiteListedTokens[i];
                SwapConfig storage swapConfig = getSwapConfig[fromToken];

                if (swapConfig.poolType == SwapPoolType.plain) {
                    swapPlainPool(swapConfig, fromToken);
                } else if (swapConfig.poolType == SwapPoolType.meta) {
                    swapMetaPool(swapConfig, fromToken);
                }
            }
        }
    }

    /* ========== INTERNAL FUNCTIONS ========== */

    function swapPlainPool(SwapConfig storage config, address fromTokenAddress) internal {
        IERC20 fromToken = IERC20(fromTokenAddress);
        uint256 inAmount = fromToken.balanceOf(address(this));
        if (inAmount > 0) {
            IRequiemStableSwap pool = IRequiemStableSwap(config.pool);
            uint8 fromIndex = pool.getTokenIndex(fromTokenAddress);
            uint8 toIndex = pool.getTokenIndex(target);
            fromToken.safeIncreaseAllowance(config.pool, inAmount);
            pool.swap(fromIndex, toIndex, inAmount, 0, block.timestamp + swapTimeout);
        }
    }

    function swapMetaPool(SwapConfig storage config, address fromTokenAddress) internal {
        IERC20 fromToken = IERC20(fromTokenAddress);
        uint256 inAmount = fromToken.balanceOf(address(this));

        if (inAmount > 0) {
            IRequiemStableSwap pool = IRequiemStableSwap(config.pool);
            IRequiemStableSwap basePool = IRequiemStableSwap(config.basePool);
            uint8 tokenIndexFrom = pool.getTokenIndex(fromTokenAddress);
            uint8 tokenIndexTo = basePool.getTokenIndex(target);
            fromToken.safeIncreaseAllowance(address(swapRouter), inAmount);
            swapRouter.swapToBase(
                pool,
                basePool,
                tokenIndexFrom,
                tokenIndexTo,
                inAmount,
                0,
                block.timestamp + swapTimeout
            );
        }
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function initialize(address _target, address _swapRouter) external onlyOwner initializer {
        target = _target;
        swapRouter = RequiemStableSwapRouter(_swapRouter);
    }

    function toggleOperator(address _operator) external onlyOwner {
        operators[_operator] = !operators[_operator];
    }

    function setSwapConfig(
        address _fromToken,
        SwapPoolType poolType,
        address pool,
        address basePool
    ) external onlyOwner {
        require(_fromToken != address(0), "zeroFromTokenAddress");
        require(pool != address(0), "zeroPoolAddress");

        if (poolType == SwapPoolType.meta) {
            require(basePool != address(0), "zeroBasePoolAddress");
        }

        if (getSwapConfig[_fromToken].pool == address(0)) {
            whiteListedTokens.push(_fromToken);
        }

        getSwapConfig[_fromToken] = SwapConfig({poolType: poolType, pool: pool, basePool: basePool});
    }


    /* =============== EVENTS ==================== */

    event TransferFee(address caller, address to, IERC20 token, uint256 amount);
}
