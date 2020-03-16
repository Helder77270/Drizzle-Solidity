const SimpleStorage = artifacts.require("SimpleStorage");

contract("SimpleStorage", accounts => {
  it("should store the value 42.", async () => {
    const simpleStorageInstance = await SimpleStorage.deployed();

    const storedData1 = await simpleStorageInstance.storedData.call();
    assert.equal(storedData1, 42, "The value 42 was not stored.");

    await simpleStorageInstance.set(43, { from: accounts[0] });

    const storedData2 = await simpleStorageInstance.storedData.call();
    assert.equal(storedData2, 43, "The value 43 was not stored.");
  });
});
