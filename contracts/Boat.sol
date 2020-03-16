pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Boat is ERC721 {
    
    struct User{
        address addr;
        string firstname;
        string lastname;
        uint256 tokenAmount;
    }
    
       struct Approbation {
        uint id;
        uint idboat;
        address[] private_key;
        uint256 lenght;
    }
    
    // Structure du boat
    struct Boat {
        uint256 id;
        address boataddr;
        string name;
        string constructeur;
        string materiaux;
        uint256 prix;
        address ownedBy;
        address reservedBy;
        bool sold;
    }
    
    struct Approver{
        uint id;
        string name;
        bool authorized;
        bool exists;
        uint availableApprovals;
    }

    // Store boat - Fetch boat (Stocke les ID du boat dans une map)
    mapping(uint => Boat) public boats;
    mapping(uint => Approbation) public private_keys;
    mapping(address => User) public users;
    mapping(address => bool) public approved;
    mapping(address => Approver) public approvers; // Tableau de clé address | valeur struct Approver 
    
    event addedBoat(string _name, uint price);
    event addedApprover(string _name, bool authorized);
    event addedUser(string _fn, string _ln);
    event reservedBoat(uint _id);
    // Store boats Count
    address payable owner; 

    uint idCounter;
    uint approversCounter;
    uint256 NBRE_APPROVAL_NEEDED = 2;
    event paymentApproved(address _a, address _b, uint256 _amount);
    uint public boatsCount;
    
    // Constructor
    constructor () public {
        owner = msg.sender;
        
    }
    
    // ----- Modifer ----- //
    
    modifier ContractDeployerOnly(){ 
        require(msg.sender == owner,"Seule la personne qui a déployée le contrat peut utiliser cette fonction !"); 
        _; 
    }
    
    //----- Functions -----
    
    // Ajout d'un boat
    function addBoat (string memory _name,address _boatAddr ,string memory _constructeur,  string memory _materiaux, address _addr, uint256 _prix) ContractDeployerOnly public {
        boatsCount ++;
        require(_prix > 0, "Le prix doit être plus grand que 0.");
        boats[boatsCount] = Boat(boatsCount, _boatAddr, _name, _constructeur, _materiaux, _prix,_addr,address(0),false);
        
        emit addedBoat(_name,_prix);
    }
    
    function addApprover(address _apprAdd,string memory _name) ContractDeployerOnly public {
        require(!approvers[_apprAdd].exists);
        approversCounter +=1;
        approvers[_apprAdd] = Approver(approversCounter,_name,false,true,999); // Création d'un bateau avec nom, et 0 approbation dessus
        emit addedApprover(_name,false);
    }
    
    function addUser(address _addr, string memory _fn, string memory _ln, uint256 _amount) public {
        require(_amount >= 0 , "Vous ne pouvez pas ajouter un compte déjà en négatif");
        users[_addr] = User(_addr, _fn, _ln,_amount);
        emit addedUser(_fn,_ln);
    }
    
    function getBoat(uint256 _id) public view returns(uint256, string memory, string memory, string memory, uint256, address, address) {
        Boat memory b = boats[_id];
        
        return (
             b.id,
             b.name,
             b.constructeur,
             b.materiaux,
             b.prix,
             b.ownedBy,
             b.reservedBy
         );
    }
    
    
    function signing(address _signer, uint _id) public {
        
       // require(approvers[_signer].authorized,"Vous n'êtes pas autorisé à approuver un bateau !!!");
        require(!hasAlreadyApproved(_signer,_id), "Vous avez déjà approuvé ce bateau !");
        require(private_keys[_id].lenght < NBRE_APPROVAL_NEEDED, "2 utilisateurs approuvés ont déjà validés cet achat");
        
        idCounter++;
        
        private_keys[_id].id = idCounter;
        private_keys[_id].idboat = _id;
        private_keys[_id].private_key.push(_signer);
        private_keys[_id].lenght += 1;
        
        if(private_keys[_id].lenght == NBRE_APPROVAL_NEEDED){
            buy(boats[_id].reservedBy, boats[_id].ownedBy,boats[_id].prix,boats[_id].id );
            setSoldStatus(true,_id);
            emit paymentApproved(boats[_id].reservedBy,boats[_id].ownedBy,boats[_id].prix);
                
        }
     
    }
    
    function setReservation(address _addr, uint256 _id) public {
        
        require(!boats[_id].sold,"Vous ne pouvez pas réserver ce bateau car il est déjà vendu");
        boats[_id].reservedBy = _addr;
        emit reservedBoat(_id);
    }
    
    function setSoldStatus(bool _sold, uint256 _id) public {
        boats[_id].sold = _sold;
    }
    
    function setOwner(address _addr, uint256 _id) public {
        boats[_id].ownedBy = _addr;
    }
    
    function buy(address _from, address _to, uint256 _amount, uint256 _id) public {
        require(_from != _to,"Vous ne pouvez pas vous acheter votre propre bateau !");
        require(users[_from].tokenAmount >= _amount, "Fonds insufisants");
        
        users[_from].tokenAmount -= _amount;
        users[_to].tokenAmount += _amount;
        setOwner(_from,_id);
        setReservation(address(0),_id);
        
    }
    
    function hasAlreadyApproved(address _signer, uint256 _id) public view returns(bool){
        for(uint i = 0; i < private_keys[_id].lenght; i++){
            if(_signer == private_keys[_id].private_key[i]){
                return true;
            }
        }
        return false;
    }
    
    
    function end() ContractDeployerOnly public {
        selfdestruct(owner); // selfdestruct detruit le contrat courant
    }
}

