//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract singleVoting {

   // state variables
   address admin;
   bool isVotingStarted;
   bool isVotingEnd;

   struct Voter{
        address userAddress;
        uint256 userId;
        bool isRegistered;
        bool isVoted;
        uint256 votes;
    }

    mapping(address => Voter) public voterRecords;
    address[] public addressIndices;

    event NewUserRegistered(address indexed _user, uint256 indexed _userId, uint256 indexed timestamp);
    event VotingStateChanged(bool indexed isVotingStarted, uint256 indexed timestamp);

    event WinnerDeclare(address indexed _user, uint256 indexed votes, uint256 indexed timestamp);

    event VoteCast(address indexed _user, address indexed candidate, uint256 indexed timestamp);

    modifier checkUser(address _userAddress){
        require(_userAddress == msg.sender, "Impersonating user - Bad call");
        _;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin, "Only admin shoule be here");
        _;
    }

   constructor(uint256 _id) {
        admin = msg.sender;
        Voter memory newUser;
        newUser.userAddress = msg.sender;
        newUser.userId = _id;
        newUser.isRegistered = true;
        voterRecords[msg.sender] = newUser;
        addressIndices.push(msg.sender);
   }

   function register(address _userAddress, uint256 _id) external checkUser(_userAddress) {

        require(!isVotingStarted, "Candidates should register before voting started");
        Voter memory newUser;

        newUser.userAddress = msg.sender;
        newUser.userId = _id;
        newUser.isRegistered = true;

        voterRecords[msg.sender] = newUser;

        addressIndices.push(msg.sender);
        emit NewUserRegistered(msg.sender, _id, block.timestamp);
    }

    function votingStarted() external onlyAdmin {
        isVotingStarted = true;
        emit VotingStateChanged(isVotingStarted, block.timestamp);
    }

    function votingEndedandDeclareWinner() external onlyAdmin returns(address) {
        isVotingEnd = true;
        emit VotingStateChanged(isVotingStarted, block.timestamp);

        uint arrayLength = addressIndices.length;
        Voter memory winner;
        for (uint i=0; i<arrayLength; i++) {
            Voter memory voter = voterRecords[addressIndices[i]];
            if (voter.votes > winner.votes) {
                winner = voter;
            }
        }

        emit WinnerDeclare(winner.userAddress, winner.votes, block.timestamp);
        return winner.userAddress;

    }

    function vote(address _addr) external {
        require(isVotingStarted, "Voting not started yet");
        require(!isVotingEnd, "Voting has been ended");
        Voter storage voter = voterRecords[msg.sender];
        Voter storage candidate = voterRecords[_addr];

        require(voter.isRegistered, "Voter is not registered voter");
        require(!voter.isVoted, "Voter is already cast his/her vote");

        require(candidate.isRegistered, "Invalid vote cast");

        candidate.votes += 1;
        voter.isVoted = true;

        emit VoteCast(msg.sender, _addr, block.timestamp);
    }
}