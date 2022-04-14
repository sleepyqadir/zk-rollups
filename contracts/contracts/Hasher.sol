//SPDX-License-Identifier: Unlicense

/*
 * Hasher object to abstract out hashing logic
 * to be shared between multiple files
 *
 * Copyright (C) 2020 Elliot Stefansson <stealthy-ai@protonmail.com>
 *
 * This file is part of simple-zk-rollups
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 */

pragma solidity ^0.8.0;


import "./MiMc.sol";

contract Hasher {
  function hashMulti(uint256[] memory array, uint256 key)
    public
    pure
    returns (uint256)
  {

    /* 

    The prime field we work in when programming zkSNARKs is defined by
    the elliptic curve chosen to implement a zkSNARK proving system.
    To be more precise, the prime p which represents the field modulus
    is defined by the group order r of the elliptic curve.
    This will become clearer after elliptic curves have been introduced in the following section.

    Ethereum provides pre-compiled contracts for the BN128 (also known as BN254) curve,
    which enable cheap curve operation on the blockchain. Operations inside a zkSNARK program,
    constructed using that curve, will wrap around the prime:

    p = 21888242871839275222246405745257275088548364400416034343698204186575808495617

    which equates to the group order r of BN128.
    Hence, if we want to be able to verify zkSNARKs on Ethereum,
    we use this p as the modulus in ZoKrates programs.
   
   
    */

    uint256 k = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256 R = 0;
    uint256 C = 0;

    for (uint256 i = 0; i < array.length; i++) {
      
      /*
      
       equation a + b = c (mod p)
      
       */
       R = addmod(R, array[i], k); 
      (R, C) = MiMC.MiMCSponge(R, C, key);
    }

    return R;
  }

  function hashPair(uint256 left, uint256 right) public pure returns (uint256) {
    uint256[] memory arr = new uint256[](2);
    arr[0] = left;
    arr[1] = right;

    return hashMulti(arr, 0);
  }

  function hashBalanceTreeLeaf(
    uint256 publicKeyX,
    uint256 publicKeyY,
    uint256 balance,
    uint256 nonce
  ) public pure returns (uint256) {
    uint256[] memory arr = new uint256[](4);
    arr[0] = publicKeyX;
    arr[1] = publicKeyY;
    arr[2] = balance;
    arr[3] = nonce;

    return hashMulti(arr, 0);
  }
}
