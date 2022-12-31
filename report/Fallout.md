# Fallback challenge writeup

## Challenge Description
`Fallout` contract is almost same as `FallBack` contract but it use old version of solidity (0.6.0) and constructor is declared differently. The goal is to become the owner.

## Vulnerability
Constructor is declared with contract name which is old version. Through this it lands in contract ABI therefore the constructor becomes a publicly callable function. Then the owner is changable. 

## Attack steps
1. As a attacker call the `Fallout` function (constructor) to become the owner of contract. 
2. Get all the balance of contract through `collectAllocations` function.

## Exploit Code
There is not much exploit code required for this challenge. We simple execute the `Fallout` function to get the ownership.

## Recommendation
Use latest version of solidity and use `constructor` keyword to declare the constructor.