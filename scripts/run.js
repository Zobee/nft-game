const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
  const gameContract = await gameContractFactory.deploy(
    ["Mush", "Bork", "Bag", "Lit", "Bit", "Reap", "Jelly", "Slime", "Rob"],
    ["QmdBGMQorUzpmNmzC3WdYmyKjR5Yf2SADpVT3sueyEsFQn",
    "QmP8SyzPveVHoRqabEDFMTxANDmFi3EdRDse6FvisX2fEN",
    "QmVjpfji5QY27HMaAhXHvvHJK3nExhxuXfXJRX2fBQm31S",
    "QmWT2oAaLANiWP3e6DzVJAh5WvtFyVNgfy5RJzNzbHQhJv",
    "QmetKzVkiq39TWWAE2rFXQ5guFvQVotnfzRyjFUqsh3BPj",
    "Qmex6MY84PwGuujiJ8job2s35atbfCsRcdCKpzgivJ7TJ9",
    "QmVZKZr2MCnyra5Bsy19kfzAUom2vishav1DgknV5rACBx",
    "Qmb6ywK5UG1qh853PQQxQsJZksTf7r8vcz7NuGX3D8Jsau",
    "Qmc3AXa3EEeRoZy6PTjrBZQZPpLvLE427GdPXg6DBrbyzy"
    ],
    [350, 400, 200, 250, 250, 200, 150, 300, 250],
    [100, 150, 100, 200, 150, 400, 500, 100, 50],
    [2, 1, 5, 3, 2, 2, 1, 4, 6],
    ["Flora", "Fauna", "Bug", "Fire", "Water", "Etherial", "Electric", "Proteza", "Neo"],
    "Bojack Horseman",
    "https://i.imgur.com/WMXJaDJ.jpeg",
    100000,
    50
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  txn = await gameContract.mintJackNFT(4);
  await txn.wait();

  let returnedTokenURI = await gameContract.tokenURI(1);
  console.log("Token URI:", returnedTokenURI)

  txn = await gameContract.attackBoss();
  await txn.wait();
  txn = await gameContract.attackBoss();
  await txn.wait();
  txn = await gameContract.attackBoss();
  await txn.wait();
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();