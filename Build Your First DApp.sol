// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {
    enum PlayerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED,
        REVIEWED
    }

    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 startTime;
        uint256 endTime;
        string reviewComments;
    }

    address public admin;
    uint256 public nextQuestId;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => PlayerQuestStatus))
        public playerQuestStatuses;

    // Constructor
    constructor() {
        admin = msg.sender;
    }

    // Modifier to check if the quest exists
    modifier questExists(uint256 questId) {
        require(quests[questId].reward != 0, "Quest does not exist");
        _;
    }

    // Function to create a new quest
    // I added startTime, endTime, reviewComments variables for new ly added 2 features
    function createQuest(
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_,
        uint256 startTime_,
        uint256 endTime_
    ) external {
        require(msg.sender == admin, "Only the admin can create quests");

        quests[nextQuestId] = Quest({
            questId: nextQuestId,
            numberOfPlayers: 0,
            title: title_,
            reward: reward_,
            numberOfRewards: numberOfRewards_,
            startTime: startTime_,
            endTime: endTime_,
            reviewComments: ""
        });

        nextQuestId++;
    }

    // Function for players to join a quest
    // here this function check the start time to allow user to join after the quest started
    function joinQuest(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] ==
                PlayerQuestStatus.NOT_JOINED,
            "Player has already joined/submitted this quest"
        );
        require(
            block.timestamp >= quests[questId].startTime,
            "Quest has not started yet"
        );
        require(
            block.timestamp <= quests[questId].endTime,
            "Quest has already ended"
        );

        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.JOINED;

        quests[questId].numberOfPlayers++;
    }

    // Function for players to submit a quest
    function submitQuest(uint256 questId, string calldata reviewComments_)
        external
        questExists(questId)
    {
        require(
            playerQuestStatuses[msg.sender][questId] ==
                PlayerQuestStatus.JOINED,
            "Player must first join the quest"
        );

        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.SUBMITTED;

        quests[questId].reviewComments = reviewComments_;
    }

    // Function for the admin to review a quest submission
    // this function newly created for reviewed quest
    function reviewQuest(
        uint256 questId,
        PlayerQuestStatus status,
        string calldata reviewComments_
    ) external questExists(questId) {
        require(msg.sender == admin, "Only the admin can review quests");
        require(
            quests[questId].endTime <= block.timestamp,
            "Quest has not ended yet"
        );

        address player = msg.sender;
        playerQuestStatuses[player][questId] = status;
        quests[questId].reviewComments = reviewComments_;
    }
}
