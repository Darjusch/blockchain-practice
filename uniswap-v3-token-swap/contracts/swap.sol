// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/lens/Quoter.sol";
import "hardhat/console.sol";

contract SwapExample {

    ISwapRouter public immutable swapRouter;
    uint24 public constant poolFee = 3000;
    uint256 public num_orders;
    LimitOrder[] orders;

    event OrderCreated(address issuer, uint256 amountIn, uint256 amountOutMinimum, address tokenIn, address tokenOut);
    event OrderExecuted(address issuer, uint256 amountIn, uint256 amountOutMinimum, address tokenIn, address tokenOut);

    struct LimitOrder {
        uint256 amountIn;
        uint256 amountOutMinimum;
        address tokenIn;
        address tokenOut;
        address issuer;
        bool executed;
        bool exists;
    }

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }

    function getOrderByIndex(uint256 index) view public returns(LimitOrder memory) {
        require(orders[index].exists);
        return orders[index];
    }

    function createLimitOrder(uint256 amountIn, uint256 amountOutMinimum, address tokenIn, address tokenOut) public {
        require(amountIn > 0, "The amountIn has to bigger than 0");
        require(amountIn <= IERC20(tokenIn).allowance(msg.sender, address(this)), "The allowance is not high enough");
        console.log("ALLOWANCE: %s", IERC20(tokenIn).allowance(msg.sender, address(this)));
        orders.push(LimitOrder(amountIn, amountOutMinimum, tokenIn, tokenOut, msg.sender, false, true));
        num_orders ++;
        emit OrderCreated(msg.sender, amountIn, amountOutMinimum, tokenIn, tokenOut);
    }

    function getPrice(address tokenIn, address tokenOut, uint256 amountIn) internal returns(uint256){
        Quoter quoter = Quoter(0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6);
        uint256 amountOut = quoter.quoteExactInputSingle(tokenIn, tokenOut, poolFee, amountIn, 0);
        return amountOut;
    }

    function swapExactInputSingle(uint256 amountIn, uint256 amountOutMinimum,address tokenIn, address tokenOut) public returns (uint256 amountOut) {
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
        TransferHelper.safeApprove(tokenIn, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            });
        amountOut = swapRouter.exactInputSingle(params);
    }

    function tryOrder() public {
        for(uint256 i=0; i<num_orders; i++){
            if(orders[i].executed == true){
                continue;
            }
            uint256 price = getPrice(orders[i].tokenIn, orders[i].tokenOut, orders[i].amountIn);
            if(orders[i].amountOutMinimum <= price) {
                swapExactInputSingle(orders[i].amountIn, orders[i].amountOutMinimum, orders[i].tokenIn, orders[i].tokenOut);
                orders[i].executed = true;
                emit OrderExecuted(msg.sender, orders[i].amountIn, orders[i].amountOutMinimum, orders[i].tokenIn, orders[i].tokenOut);
            }
        }
    }
}