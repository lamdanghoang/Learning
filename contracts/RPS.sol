// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract RPSGame {
    // Rock: 0, Paper: 1, Scissors: 2
    enum Choice {
        Rock,
        Paper,
        Scissors
    }

    struct Player {
        address payable player;
        bytes32 choice;
    }

    bool public is_ended;
    uint256 public secret = random();

    Player[2] public players;

    function play(bytes32 _hash_choice) public payable {
        require(msg.value >= 10000000000000000, "Must send 0.01 Value");
        // bytes32 hash_choice = keccak256(abi.encodePacked(secret, _choice));

        if (players[0].player == address(0)) {
            players[0] = Player(payable(msg.sender), _hash_choice);
        } else {
            require(players[0].player != msg.sender, "Already played !");
            players[1] = Player(payable(msg.sender), _hash_choice);
            is_ended = true;
            transfer(payable(check_winner()));
            reset_game();
        }
    }

    function hash_choice(Choice _choice) public view returns (bytes32) {
        return keccak256(abi.encodePacked(secret, _choice));
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        msg.sender
                    )
                )
            );
    }

    function return_choice(bytes32 _hash_choice)
        private
        view
        returns (uint256)
    {
        if (keccak256(abi.encodePacked(secret, Choice.Rock)) == _hash_choice) {
            return 0;
        } else if (
            keccak256(abi.encodePacked(secret, Choice.Paper)) == _hash_choice
        ) {
            return 1;
        }
        return 2;
    }

    function check_winner() public view returns (address) {
        // require(players[0].player != address(0) && players[1].player != address(0), "Not started yet !");
        require(is_ended, "Not started yet !");

        uint256 choice_1 = return_choice(players[0].choice);
        uint256 choice_2 = return_choice(players[1].choice);

        if (choice_1 == choice_2) return address(0);
        if (choice_1 == 0 && choice_2 == 2) return players[0].player;
        if (choice_1 == 1 && choice_2 == 0) return players[0].player;
        if (choice_1 == 2 && choice_2 == 1) return players[0].player;
        return players[1].player;
    }

    function transfer(address payable _to) private {
        (bool success, ) = _to.call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }

    function reset_game() private {
        require(is_ended, "Game is not ended!");
        delete players[0];
        delete players[1];
        secret = random();
        is_ended = false;
    }
}
