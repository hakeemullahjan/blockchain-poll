pragma solidity ^0.6.6;

contract PollContract{

    struct Poll{
        uint256 id;
        string question;
        string thumbnail;
        uint64[] votes;
        bytes32[] options;
    }

    struct Voter{
        address id;
        uint256[] votesIds;
        mapping(uint256=>bool) voteMap;
    }

    Poll[] private polls;

    mapping(address=>Voter) private voters;


    event PollCreated(uint256 _pollId);

    function createPoll(string memory _question,string memory _thumb,bytes32[] memory _options) public{
        require(bytes(_question).length>0,'Empty question');
        require(_options.length>1,'Atleast two options requires');

        uint256 pollId=polls.length;

        Poll memory newPoll = Poll({
            id:pollId,
            question:_question,
            thumbnail:_thumb,
            options:_options,
            votes:new uint64[](_options.length)
        });

        polls.push(newPoll);
        emit PollCreated(pollId);
    }


    function getPoll(uint256 _pollId) external view returns (uint256,string memory,string memory, uint64[] memory, bytes32[] memory){
    require(_pollId<polls.length && _pollId>=0,"No poll found");
     return (
         polls[_pollId].id,
         polls[_pollId].question,
         polls[_pollId].thumbnail,
         polls[_pollId].votes,
         polls[_pollId].options
         );
    }


    function vote(uint256 _pollId, uint64 _vote) external {
        require(_pollId < polls.length,"Poll does not exist");
        require(_vote < polls[_pollId].options.length,"Invalid Vote");
        require(voters[msg.sender].voteMap[_pollId] == false,"You already vote");

        polls[_pollId].votes[_vote]+=1;

        voters[msg.sender].votesIds.push(_pollId);
        voters[msg.sender].voteMap[_pollId]=true;
    }

    function getVoter(address _id) external view returns (address,uint256[] memory){
    return(
    voters[_id].id,
    voters[_id].votesIds
    );
    }

    function getTotalPolls() external view returns(uint256){
        return polls.length;
    }


}

