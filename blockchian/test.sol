pragma solidity ^0.6.6;

contract Test{
    uint256 public myNumber;
    bool isActive;
    string name;
    bytes32 password;
    string[] names;

    mapping(uint256 => Person) ids;

    address id;

    struct Person{
        address id;
        string name;
        uint24 age;
        Home home;
    }

    struct Home{
        string[] addresses;
        uint16 zip;
    }

    enum Day {Sunday,Monday}

    constructor() public{
        myNumber=16;
        isActive=true;
        name='hakeemullah';
    }

    modifier isAbove10(uint256 _newNumber){
         require(_newNumber <= 10,'Number is above 10');
         _;
    }

    function setNumber(uint256 _newNumber) external payable isAbove10(_newNumber) {
    //   now
    // msg.sender=''
        myNumber=_newNumber;
    }


    function getNumber() external view returns (uint256){
       myNumber;
    }

    }















