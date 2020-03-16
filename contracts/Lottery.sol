pragma solidity 0.5.16;

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value >= 1 ether, "Miniumun amount not met");
        players.push(msg.sender);
    }

    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, now, players))
            );
    }

    modifier restricted() {
        require(
            msg.sender == manager,
            "You are not the owner of this contract"
        );
        _;
    }

    function pickWinner() public restricted {
        require(players.length > 0, "Need at least one player.");
        uint256 index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}
