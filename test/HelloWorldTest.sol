pragma solidity >=0.4.21 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HelloWorld.sol";

contract HelloWorldTest {
    function testHelloWorld() public {
        HelloWorld helloWorld = HelloWorld(DeployedAddresses.HelloWorld());

        Assert.equal(
            helloWorld.speak(),
            "Hello ESGI",
            "It should say Hello ESGI."
        );
    }
}
