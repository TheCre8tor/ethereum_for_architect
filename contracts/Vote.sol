// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    // This struct represent a single voter.
    struct Voter {
        uint256 weight; // weight is accumulated by delegation
        bool voted; // if true, that person already voted
        address delegate; // person delegated to
        uint256 vote; // index of the voted proposal
    }

    // This is a type for a single proposal
    struct Proposal {
        bytes32 name; // short name (up to 32 bytes)
        uint256 voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This store the list of voters in an object
    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    /// Creates a new ballot to choose one of the [proposalNames]
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    function giveRightToVote(address voter) external {
        /* If the first argument of [require] evaluate
           to [false], execution terminates and all
           changes to the state and to Ether balances
           are reverted. */
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );

        require(!voters[voter].voted, "The voter already voted.");

        require(voters[voter].weight == 0);

        voters[voter].weight = 1;
    }

    /// Delegate your vote to the voter [to]
    function delegate(address to) external {
        // assign reference
        Voter storage sender = voters[msg.sender];

        require(!sender.voted, "You already voted");

        require(to != msg.sender, "Self-delegation is disallowed.");

        /* This check if the address at the location of
           delegate is not 0x0 which means a zero account,
           assign voter delegate to the [to] 
           
           address(0) is equal to 0x0,
           which is an empty account.
           */
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            require(to != msg.sender, "Found loop in delegation");
        }

        // Since [sender] is a reference, this
        // modifies `voters[msg.sender].voted`
        Voter storage delegate_ = voters[to];

        // Voters cannot delegate to wallets that cannot vote.
        require(delegate_.weight >= 1);

        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            /* If the delegate already voted
               directly add to the number of votes. */
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            /* If the delegate did not vote yet,
               add to his/her weight. */
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`
    function vote(uint256 proposal) external {
        Voter storage sender = voters[msg.sender];

        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");

        sender.voted = true;
        sender.vote = proposal;

        /* If [proposal] is out of range of the array,
           this will throw automatically and revert all
           changes. */
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winingVoteCount = 0;

        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winingVoteCount) {
                winingVoteCount = proposals[p].voteCount;

                winningProposal_ = p;
            }
        }
    }
}
