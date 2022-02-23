// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/lens/Quoter.sol";
import "hardhat/console.sol";

contract SwapExample {

    ISwapRouter public immutable swapRouter;

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    uint24 public constant poolFee = 3000;

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }
    function swapExactInputSingle(uint256 amountIn, uint256 amountOutMinimum,address tokenIn, address tokenOut) public returns (uint256 amountOut) {
        // msg.sender must approve this contract

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
    
    struct LimitOrder {
        uint256 amountIn;
        uint256 amountOutMinimum;
        address tokenIn;
        address tokenOut;
        address issuer;
        bool executed;
        bool exists;
    }
    // mapping vs array what is better
    // with the mapping i dont know how to check all limit orders since we can't loop through the addresses 
    // since all of them exist except we would store the addresses in a an array
    // the problem with the array is that we can't delete items from the array because then the place is just empty thats not what we want
    // current solution is to have a field executed in each Order and set it to true after it was executed 
    // -> Problem is that the list will grow and it will take longer and longer to go through
    // mapping (address => LimitOrder) orders; 
    uint256 public num_orders;
    LimitOrder[] orders;

    function getOrderByIndex(uint256 index) view public returns(LimitOrder memory) {
        require(orders[index].exists);
        return orders[index];
    }

    event OrderCreated(address issuer, uint256 amountIn, uint256 amountOutMinimum, address tokenIn, address tokenOut);

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

    event OrderExecuted(address issuer, uint256 amountIn, uint256 amountOutMinimum, address tokenIn, address tokenOut);

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