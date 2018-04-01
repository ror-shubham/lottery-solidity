pragma solidity ^0.4.0;
contract Lottery {
    address creator;
    bytes32 public guess;
    bytes32 public guess1;
    uint public bal;
    uint  tokenToAdd;
    mapping (address=>uint) balanceOf;
    address public winnerAddress;
    bool private gameClosed = false;
    
    function Lottery(bytes32 _guess2) public{
        creator = msg.sender;
        guess = _guess2;
    }
    
    modifier onlyCreator() {
        require(msg.sender == creator); 
        _;                              
    } 
    
    function () payable public{
        uint amount = msg.value;
        tokenToAdd = amount/1000000000000000000;
        uint weiToReturn;
        weiToReturn = amount%1000000000000000000;
        msg.sender.transfer(weiToReturn);
        balanceOf[msg.sender] += tokenToAdd;
    }
    
    function makeGuess(string _guess1) payable public{
        require(balanceOf[msg.sender]>=1);
        uint amount = msg.value;
        uint tokenToSubtract = amount/1000000000000000000;
        uint weiToReturn = amount%1000000000000000000;
        balanceOf[msg.sender] -= tokenToSubtract;
        msg.sender.transfer(weiToReturn);
        if(keccak256(_guess1)==guess){
            winnerAddress = msg.sender;
        }
        guess1 = keccak256(_guess1);
    }
    
    function closeGame() onlyCreator public{
        gameClosed=true;
        if(winnerAddress!=0x0000000000000000000000000000000000000000){
            //if someone won
            uint amount = this.balance;
            creator.transfer(amount/2);
            winnerAddress.transfer(amount/2);
        }
        else{
            //if no-one won
            creator.transfer(amount);
        }
    }
    
    function winnerAddress() view public returns(address){
        require(gameClosed==true);
        return winnerAddress;
    }
}
