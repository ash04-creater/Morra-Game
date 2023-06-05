// contract address : 0x7c7efD9E13EcBF3063eaB7d915be8f8dAD7EE165

pragma solidity ^0.8.7;
contract hello{

mapping(address => uint) balance;
mapping(address => bytes32) public hash_move;
mapping(address => int) public move;
uint count=0;
uint reveal_first=0;
uint reveal_second=0;
address first_adr;
address second_adr;

function initialize() public payable returns (uint){

    require(msg.value>1e15 && count <2,"0");

        if(count==0){
            balance[msg.sender]+=msg.value;
            first_adr=msg.sender;
            count++;
            return 1;
        }
        else{
            require(msg.sender!=first_adr,"0");

                require(msg.value > balance[first_adr],"0");

                    balance[msg.sender]+=msg.value;
                    second_adr=msg.sender;
                    count++;
                    return 2;
        }  
}

function commitmove(bytes32 hashMove) public returns (bool){

    require(count==2,"false");

    require(msg.sender == first_adr || msg.sender == second_adr,"false");

    require(hash_move[msg.sender]==0,"false");

    hash_move[msg.sender]=hashMove;

    return true;

}

function getFirstChar(string memory str) private pure returns (int) {
    if (bytes(str)[0] == 0x30) {
    return 0;
    } 
    else if (bytes(str)[0] == 0x31) {
    return 1;
    } 
    else if (bytes(str)[0] == 0x32) {
    return 2;
    } 
    else if (bytes(str)[0] == 0x33) {
    return 3;
    } 
    else if (bytes(str)[0] == 0x34) {
    return 4;
    } 
    else if (bytes(str)[0] == 0x35) {
    return 5;
    } 
    else {
    return -1;
    }
}

function revealmove(string memory revealedMove) public returns (int){

    require(count==2,"-1");

    require(msg.sender == first_adr || msg.sender == second_adr,"-1");

    require(hash_move[first_adr]!=0 && hash_move[second_adr]!=0, "-1");

    require(sha256(abi.encodePacked(revealedMove))==hash_move[msg.sender],"-1");

    move[msg.sender]=getFirstChar(revealedMove);

    if(msg.sender ==  first_adr)
    reveal_first=1;
    else
    reveal_second=1;

    if(reveal_first==1 && reveal_second==1){

        if(move[first_adr]==move[second_adr]){

            payable(second_adr).transfer(address(this).balance);
        }
        else
        payable(first_adr).transfer(address(this).balance);

        count=0;
        reveal_first=0;
        reveal_second=0;
        balance[first_adr]=0;
        balance[second_adr]=0;
        hash_move[first_adr]=0;
        hash_move[second_adr]=0;
    }

    return move[msg.sender];
}

}
