// SPDX-License-Identifier: MIT
// ERC-PIN is a next-generation standard for unique, verifiable, and fully on-chain Punk identities on Ethereum.
// Twitter: https://x.com/punkifyERC
// Telegram: https://t.me/punkifyERC

pragma solidity ^0.8.30;

/// @title IPunkify - ERC721A
interface IPunkify {
    function mint(uint256 quantity, address to) external;
}

contract Punkify {
    // Ownable
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    IPunkify public PunkifyNFT;

    uint256 public nonce = 1;

    string public name = "Punkify";
    string public symbol = "P";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = tx.origin;
        totalSupply = 100 * (10 ** uint256(decimals));
        balanceOf[tx.origin] = totalSupply;
        emit Transfer(address(0), tx.origin, totalSupply);
    }

    // Transfer ownership to new address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address not allowed");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Renounce ownership (set owner to zero address)
    function renounceOwnership() external onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    // Set NFT contract address
    function setPunkifyNFT(address _punkify) external onlyOwner {
        require(_punkify != address(0), "Invalid address");
        PunkifyNFT = IPunkify(_punkify);
    }

    function createNFT(uint256 amount) external{
        require(balanceOf[msg.sender] >= amount , "Insufficient balance");
        uint256 quantity = amount / 1e18;
        _transfer(msg.sender, address(0), amount);
        PunkifyNFT.mint(quantity, msg.sender);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
}

