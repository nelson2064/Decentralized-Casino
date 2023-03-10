//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

//Decentralized Casino which will have a funciton where people can send ether to the contract and they have 50 50 percent chance to win and double their money and if they loose the contract will keep the money so naturally there need to be someway to fund this contruct and people actually put inof ether to the contract so other people can play  and off course there have to be a way to someone actually retrive the funds that this contract here will have but we will leave that out we will only fous on actual game function so to do that we gona use randomness future block hash 


// Decentralized Cashino 
// 1.function people can send ether to the contract
// 2.50 50 percent chance to win to double their money
// 3.if they loose contract will keep the money 
// 4.someway to fund this contract and people actually put inoff eth into the contract so other people can paly
// 5.a way for someone to retrive the fund that this  contract will have but we will leave that out we will only focus on actual game funciton  


// to do that we gonna use randomeness as we discuss before using a future block hash

contract Casino{
  

mapping (address => uint256) public gameWeiValues; //one mapping for which will keep tract of ether or wei people are playing
mapping(address => uint256) public blockHashesToBeUsed;//second mapping  we will keep track of the number of the block hash that is suppose to be used for each game

function playGame() external payable{//function play game which is external and payable people can send ether along
    
    //in the first case when someone calling palygame for the first time we have to figure out he is calling for the first time and we will check that by looking block hashed used
   
//   1 . first case when someone calling play game for the first time > we check by looking at block has to be used if 0 he called it for the first time

    if(blockHashesToBeUsed[msg.sender] == 0){ //if blockhasestobeused is 0 we know he called it for the first time and we are'nt actually playing it we determing which block has to be used for the randomness 
        blockHashesToBeUsed[msg.sender] = block.number + 2; //you can use more but two should be inof   so that this block has not be know at a time  when the msg.sender calling the play game for the first time
        gameWeiValues[msg.sender] = msg.value; // and then we also store the amount he played the ethers he send along msg.value we will just keep ether in the contract and this will be determing if he wins   he send we will keep eth in the contract 
        return;
    }

// 2 . other wise we play the actual game for the second time

require(msg.value == 0, "Lottery: Finish current game before starting now one");  //let the first game to be finished if he send other ether to play we don't give him to play first finished the first game 
require(blockhash(blockHashesToBeUsed[msg.sender]) != 0 , "Lottery: Block not mined yet"); //we also have to  check that the block is mined          that should not be zero if zero that means block is not mined yet



// 3. converting the hash into uint256

//we know block is mined now we can safely calculated random number 
uint256 randomNumber = uint256(blockhash(blockHashesToBeUsed[msg.sender]));  //so now we know block is mined => and we can pass directly into uint256 to get number from this block hash here > now we have random uint256 number we can use


//4. how do we determine he wins?

if(  randomNumber !=0 &&   randomNumber % 2 == 0){  //if random number truns out to be even he wins if it odds he looses so in the case he loose we don't have to do anything we just kept the money if he wins we have to send the amount to him
    uint256 winningAmount = gameWeiValues[msg.sender] * 2; //the amount he will recive is the amount he send previously * 2
    (bool success, ) = msg.sender.call{value: winningAmount}(""); //and now we transfer back in the way we did several times
    require(success , "Lottery: Winning payout failed");//if the transfer fails too bad for him so if succes fine if not message
}
//now after finishing his game we just make all thing zero )
blockHashesToBeUsed[msg.sender] = 0;
gameWeiValues[msg.sender] = 0;


}



}