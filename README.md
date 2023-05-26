# StackUp---Build-Your-First-DApp-Bounty

The additional features added to the smart contract are Quest Review Functionality and Quest Start and End Time. These features were chosen to align the smart contract with StackUp's functionalities and enhance the user experience.

# Quest Review Functionality:

Reason: The quest review functionality allows the admin to evaluate and provide feedback on quest submissions by players. This feature adds an element of validation and quality control to the platform.
How it works: After a player submits a quest, the admin can review the submission and update the status accordingly. The admin can reject, approve, or reward the submission based on their assessment. The admin's review comments are stored in the reviewComments field of the corresponding quest struct.

# Quest Start and End Time:

Reason: Introducing quest start and end times adds time-based restrictions to the platform, mimicking StackUp's real-time quest availability. This feature ensures that players can only join quests that are active and prevents joining quests that have already ended.
How it works: Each quest struct now includes startTime and endTime fields, representing Unix timestamps. Before a player joins a quest, the contract checks if the current time is within the quest's start and end time range. If the quest has not started or has already ended, the player is not allowed to join.

By incorporating these features, the smart contract replicates StackUp's functionalities more closely. The quest review functionality provides an evaluation mechanism for quest submissions, while the quest start and end time restrictions enforce real-time quest availability, enhancing the overall user experience and platform governance.
