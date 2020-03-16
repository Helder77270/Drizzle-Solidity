const HelloWorld = artifacts.require("HelloWorld");

contract("HelloWorld", accounts => {
  it("should say Hello ESGI", async () => {
    const helloWorldInstance = await HelloWorld.deployed();

    const reply = await helloWorldInstance.speak.call();

    assert.equal(reply, "Hello ESGI", "The returned value is not correct.");
  });
});
