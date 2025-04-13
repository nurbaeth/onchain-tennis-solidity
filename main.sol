// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OnchainTennis {
    address public player1;
    address public player2;
    address public currentServer;
    address public currentHitter;

    enum GameState { WaitingForPlayers, Ready, InPlay, Finished }
    GameState public gameState;

    mapping(address => uint8) public points; // up to 4: 0, 15, 30, 40

    event GameStarted(address player1, address player2);
    event Serve(address server);
    event Hit(address hitter);
    event PointWon(address winner, uint8 p1Score, uint8 p2Score);
    event GameOver(address winner);

    modifier onlyPlayers() {
        require(msg.sender == player1 || msg.sender == player2, "Not a player");
        _;
    }

    modifier inState(GameState state) {
        require(gameState == state, "Invalid state");
        _;
    }

    constructor() {
        gameState = GameState.WaitingForPlayers;
    }

    function joinGame() external inState(GameState.WaitingForPlayers) {
        require(msg.sender != player1, "Already joined");

        if (player1 == address(0)) {
            player1 = msg.sender;
        } else {
            player2 = msg.sender;
            currentServer = player1;
            currentHitter = player2;
            gameState = GameState.Ready;
            emit GameStarted(player1, player2);
        }
    }

    function serve() external inState(GameState.Ready) onlyPlayers {
        require(msg.sender == currentServer, "Not your serve");

        gameState = GameState.InPlay;
        emit Serve(msg.sender);
    }

    function hit() external inState(GameState.InPlay) onlyPlayers {
        require(msg.sender == currentHitter, "Not your turn");

        // Random chance of miss (simulate with block randomness for now)
        if (randomMiss()) {
            address winner = (msg.sender == player1) ? player2 : player1;
            points[winner]++;
            emit PointWon(winner, points[player1], points[player2]);

            // Check for win condition
            if (hasWon(winner)) {
                gameState = GameState.Finished;
                emit GameOver(winner);
            } else {
                // Reset roles
                currentServer = winner;
                currentHitter = (winner == player1) ? player2 : player1;
                gameState = GameState.Ready;
            }
        } else {
            // rally continues
            currentHitter = (msg.sender == player1) ? player2 : player1;
            emit Hit(msg.sender);
        }
    }

    function hasWon(address player) internal view returns (bool) {
        return points[player] >= 4 && (points[player] - points[opponent(player)]) >= 2;
    }

    function opponent(address player) internal view returns (address) {
        return (player == player1) ? player2 : player1;
    }

    function randomMiss() internal view returns (bool) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, blockhash(block.number - 1)))) % 4 == 0;
    }

    function resetGame() external {
        require(gameState == GameState.Finished, "Game not finished yet");

        points[player1] = 0;
        points[player2] = 0;
        gameState = GameState.Ready;

        // Winner serves next game
        currentHitter = (currentServer == player1) ? player2 : player1;
    }
}
