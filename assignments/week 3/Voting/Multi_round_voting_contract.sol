//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract MultiRoundVoting {
    // state variables
    address admin;
    uint roundNumber;

    bool[] isVotingStarted;

    struct Voter{
        address userAddress;
        bool isRegistered;
        bool isVoted;
        uint256 votes;
    }

    mapping(uint => mapping(address => Voter)) public voterRecords;
    address[] public addressIndices;

    event NewUserRegistered(address indexed _user, uint256 indexed roundNumber, uint256 indexed timestamp);
    event VotingStateChanged(bool indexed isVotingStarted, uint roundNo, uint256 indexed timestamp);

    event WinnerDeclare(address indexed _user, uint256 indexed votes, uint256 roundNumber, uint256 indexed timestamp);

    event VoteCast(address indexed _user, address indexed candidate, uint256 indexed timestamp);

    modifier checkUser(address _userAddress){
        require(_userAddress == msg.sender, "Impersonating user - Bad call");
        _;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin, "Only admin shoule be here");
        _;
    }

   constructor() {
        admin = msg.sender;
   }

   function register(address _userAddress, uint roundNo) external checkUser(_userAddress) {

        require(!isVotingStarted[roundNo], "Candidates should register before voting started or voting has been ended");
        Voter memory newUser;

        newUser.userAddress = msg.sender;
        newUser.isRegistered = true;

        voterRecords[roundNo][msg.sender] = newUser;

        addressIndices.push(msg.sender);
        emit NewUserRegistered(msg.sender, roundNo, block.timestamp);
    }

    function changeVotingState(uint roundNo) external onlyAdmin {
        isVotingStarted[roundNo] = !isVotingStarted[roundNo];
        emit VotingStateChanged(isVotingStarted[roundNo], roundNo, block.timestamp);
    }

    function votingEndedandDeclareWinner(uint roundNo) external onlyAdmin returns(address) {
        isVotingStarted[roundNo] = false;
        emit VotingStateChanged(isVotingStarted[roundNo], roundNo, block.timestamp);

        uint arrayLength = addressIndices.length;
        Voter memory winner;
        for (uint i=0; i<arrayLength; i++) {
            Voter memory voter = voterRecords[roundNo][addressIndices[i]];
            if (voter.votes > winner.votes) {
                winner = voter;
            }
        }

        emit WinnerDeclare(winner.userAddress, winner.votes, roundNo, block.timestamp);
        roundNumber++;

        addressIndices=new address[](0);
        return winner.userAddress;

    }

    function vote(address _addr, uint256 roundNo) external {
        require(isVotingStarted[roundNo], "Voting not started yet or ended");
        Voter storage voter = voterRecords[roundNo][msg.sender];
        Voter storage candidate = voterRecords[roundNo][_addr];

        require(voter.isRegistered, "Voter is not registered voter");
        require(!voter.isVoted, "Voter is already cast his/her vote");

        require(candidate.isRegistered, "Invalid vote cast");

        candidate.votes += 1;
        voter.isVoted = true;

        emit VoteCast(msg.sender, _addr, block.timestamp);
    }
}
