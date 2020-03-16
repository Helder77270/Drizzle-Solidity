pragma solidity 0.5.16;

contract SimpleStorage {
    uint256 public storedData;
    event StorageSet(string _message);

    constructor(uint256 data) public {
        storedData = data;
    }

    function set(uint256 data) public {
        storedData = data;
        emit StorageSet("Data stored successfully!");
    }

    function get() public view returns (uint256 retVal) {
        return storedData;
    }
}
