pragma solidity ^0.7.5;
import "./onlyOwner.sol";
interface govermentInterface {
    function govermentTransactions(address _from, address _to, uint _amount) external ;
}

contract bankSystem is ownableContract {
    govermentInterface goverment = govermentInterface(0x9d83e140330758a8fFD07F8Bd73e86ebcA8a5692);



    mapping (address => uint) storeData ;
    function deposite() public payable
    {
      storeData[msg.sender] += msg.value;
      emit depositeEvent(msg.sender, msg.value);
    }
    function transfer(address sendTo, uint amount) public 
    {
        require(msg.sender != sendTo, "self Transaction.. please change the address");
        require(storeData[msg.sender] >= amount, "balance not Avaiable");
        uint prevBalance = storeData[msg.sender];
        storeData[msg.sender] -= amount;
        storeData[sendTo] += amount;
        assert(storeData[msg.sender] == prevBalance - amount);
        emit transferEvent(msg.sender, sendTo, amount);
        goverment.govermentTransactions(msg.sender, sendTo, amount);
    }
    function withdraw(uint amount) public 
    {
        require(storeData[msg.sender] >= amount, "balance not Avaiable");
        uint prevBalance = storeData[msg.sender];
        payable(msg.sender).transfer(amount);
        storeData[msg.sender] -= amount;
        assert(storeData[msg.sender] == prevBalance - amount);
        emit withdrawEvent(msg.sender, amount); 
    }
    function getMybalance() public view returns(uint)
    {
         return storeData[msg.sender];
    }
    function getContractBlanace() public onlyOwner view returns(uint)
    {
        return address(this).balance;
    }

    function getOwner() public view returns(address)
    {
        return ownerName;
    }
    event depositeEvent(address depositeAddress, uint amount);
    event transferEvent(address from, address to, uint amount);
    event withdrawEvent(address withDrawAddress, uint amount);

}