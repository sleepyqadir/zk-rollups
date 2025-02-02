pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Whitelist is Ownable {
  mapping(address => bool) whitelist;

  modifier whitelisted() {
    require(whitelist[msg.sender], "Whitelist: caller is not in the whitelist");
    _;
  }

  function whitelistAddress(address user) public onlyOwner {
    whitelist[user] = true;
  }

  function unWhitelistAddress(address user) public onlyOwner {
    whitelist[user] = false;
  }
}
