// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.6;

//dependencies
import "./FlashLoanReceiverBase.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";

contract FlashloanV1 is FlashLoanReceiverBaseV1 {

    // DAI Lending Pool
    constructor(address _addressProvider) FlashLoanReceiverBaseV1(_addressProvider) public{}


       // Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
    
 function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether;

        ILendingPoolV1 lendingPool = ILendingPoolV1(addressesProvider.getLendingPool());
        
        // params: address to which loan is paid back, amount of asset, fee, data
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }

  
  // after the contract has received the flash loaned amount
   
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");
       //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

}
