pragma solidity >=0.4.21 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleStorage.sol";

contract SimpleStorageTest {
    function testItStoresAValue() public {
        SimpleStorage simpleStorage = SimpleStorage(
            DeployedAddresses.SimpleStorage()
        );

        Assert.equal(
            simpleStorage.storedData(),
            42,
            "It should store the value 42."
        );

        simpleStorage.set(43);

        Assert.equal(
            simpleStorage.storedData(),
            43,
            "It should store the value 43."
        );
    }
}
