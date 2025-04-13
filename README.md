# 🎾 Onchain Tennis (Solidity)

**Fully on-chain 2-player Tennis game built with pure Solidity.**  
No tokens. No rewards. Just game logic, rallies, and the thrill of scoring — all happening directly on the Ethereum blockchain.

---

## ⚙️ Features

- 👥 2-player competitive gameplay
- 🏓 Serve, hit, and win rallies
- 🎯 Win condition: 4 points with 2-point lead (like real tennis)
- 🔄 Random miss simulation (block-based pseudo-randomness)
- 🔁 Game reset after each match

---

## 📜 How It Works

1. Two players join the game using `joinGame()`.
2. The first player becomes the server.
3. Serve the ball with `serve()`.
4. Rally begins: players hit alternately with `hit()`.
5. Random misses are possible — rally ends, point awarded.
6. First player to reach 4 points with a 2-point lead wins.
7. Game can be reset with `resetGame()`.

---

## 🔐 No Tokens, No Airdrops

This is **pure logic on-chain** — no ERC-20s, NFTs, or rewards.
It's designed to be an experiment in game mechanics and smart contract gameplay.

---

## 🛠 Deployment & Testing

Deploy using **Remix**, **Foundry**, or **Hardhat**.

### Example (Hardhat):

```bash
npx hardhat compile
npx hardhat test
