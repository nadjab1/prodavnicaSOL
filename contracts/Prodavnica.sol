// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Prodavnica {
  struct Proizvod {
    string name;
    uint price;
    uint quantity;
  }
  mapping(uint =>Proizvod) public products;
  mapping(string=>uint) public productIds;
  uint public productCount;
  address payable public owner;
  event ProductPurchased(address buyer, string productName, uint price);

constructor(address payable _owner) {
    owner= _owner;
}

  function addProduct(string memory _name, uint _price, uint _quantity) public {
    require(msg.sender == owner, "Samo vlasnik moze izvrsiti ovu akciju.");
    require(_price > 0, "Cena mora biti veca od 0.");
    require(_quantity > 0, "Kolicina mora biti veca od 0.");
    if (productIds[_name] != 0) {
      uint productId = productIds[_name];
      products[productId].quantity += _quantity;
    } else {
      productCount++;
      products[productCount] = Proizvod(_name, _price, _quantity);
      productIds[_name] = productCount;
    }
  }

  function buyProduct(uint _productId,uint kolicina) public payable {
    Proizvod storage product = products[_productId];
    require(_productId > 0 && _productId <= productCount, "Proizvod ne postoji.");
    require(msg.value >= product.price, "Nedovoljno sredstava za kupovinu.");
    require(product.quantity > 0, "Proizvod nije na zalihama.");
     require(product.quantity >= kolicina, "Nema dovoljno proizvoda na lageru.");
    owner.transfer(msg.value);
    product.quantity=product.quantity-kolicina;
    emit ProductPurchased(msg.sender, product.name, product.price);
  }
  }
