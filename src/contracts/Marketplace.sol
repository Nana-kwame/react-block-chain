pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint256 public productCount = 0;

    //* Hashmap for mapping ids unto products *//
    mapping(uint256 => Product) public products;

    //** Structure/ Object creation */
    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }

    //**Event emitted after prodcut created executed */
    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    // Event emitted after product has been purchased 
    event ProductPurchased (
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Dapp University Marketplace";
    }

    function createProduct(string memory _name, uint256 _price) public {
        // Require a valid name
        require(bytes(_name).length > 0);

        // Require a valid price
        require(_price > 0);

        // Increase the product count
        productCount++;

        // Create the product
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );

        // Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        // Fetch the product
        Product memory _product = products[_id];

        // Fetch the owner
        address payable _seller = _product.owner;

        // Confirm product has valid id
        require(_product.id > 0 && _product.id <= productCount);

        // Confirm that there is enough Ether in the transaction
        require(msg.value >= _product.price);

        // Confirm that the product has not been purchased already
        require(!_product.purchased);

        // Confirm that the buyer is not the seller
        require(_seller != msg.sender);

        // Transfer ownership to the buyer
        _product.owner = msg.sender;

        // Mark as purchased
        _product.purchased = true;

        // Update the product
        products[_id] = _product;

        // Pay the seller by sending them Ether
        address(_seller).transfer(msg.value);

        // Trigger the addition event
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}
