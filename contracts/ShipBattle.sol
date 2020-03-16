pragma solidity 0.5.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ShipBattle is ERC721 {
    struct Ship {
        string name;
        uint256 attack;
        uint256 class;
        uint256 cabin;
        uint256 engine;
        uint256 guns;
        uint256 wings;
        uint256 flame;
    }

    Ship[] public ships;

    function createShip(string memory _name) public {
        uint256 id = ships.length;
        string memory name = _name;
        uint256 rand = uint256(keccak256(abi.encodePacked(name)));

        uint256 attack = rand % 5;
        uint256 class = (2 * rand) % 3;
        uint256 cabin = (3 * rand) % 3;
        uint256 engine = (4 * rand) % 5;
        uint256 guns = (5 * rand) % 5;
        uint256 wings = (6 * rand) % 5;
        uint256 flame = (7 * rand) % 5;

        ships.push(
            Ship(name, attack, class, cabin, engine, guns, wings, flame)
        );
        _mint(msg.sender, id);
    }

    function transferShip(address _to, uint256 _id) public {
        require(ships.length >= _id, "ID not available");
        transferFrom(msg.sender, _to, _id);
    }

    function getShipCount() public view returns (uint256) {
        return ships.length;
    }

    function getShipName(uint256 _id) public view returns (string memory) {
        require(ships.length >= _id, "ID not available");
        return ships[_id].name;
    }

    function getShipAttack(uint256 _id) public view returns (uint256) {
        require(ships.length >= _id, "ID not available");
        return ships[_id].attack;
    }

    function getShipCode(uint256 _id)
        public
        view
        returns (
            uint256 class,
            uint256 cabin,
            uint256 engine,
            uint256 guns,
            uint256 wings,
            uint256 flame
        )
    {
        require(ships.length >= _id, "ID not available");
        return (
            ships[_id].class,
            ships[_id].cabin,
            ships[_id].engine,
            ships[_id].guns,
            ships[_id].wings,
            ships[_id].flame
        );
    }

    function battle(uint256 _id1, uint256 _id2)
        public
        view
        returns (string memory)
    {
        require(ships.length >= _id1, "ID1 not available");
        require(ships.length >= _id2, "ID2 not available");
        if (ships[_id1].attack >= ships[_id2].attack) return ships[_id1].name;
        return ships[_id2].name;
    }
}
