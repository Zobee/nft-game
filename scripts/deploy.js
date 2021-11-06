const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
  const gameContract = await gameContractFactory.deploy(
    ["Jack Black", "Jack White", "Samurai Jack"],
    ["https://i.imgur.com/ylOYBpT.jpeg",
    "https://i.imgur.com/PdXOYAL.jpeg",
    "https://i.imgur.com/j4cFFc8.jpeg"],
    [350, 200, 100],
    [100, 150, 225],
    "Bojack Horseman",
    "https://i.imgur.com/WMXJaDJ.jpeg",
    100000,
    50
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  txn = await gameContract.mintJackNFT(2);
  await txn.wait();
  txn = await gameContract.attackBoss();
  await txn.wait();
  txn = await gameContract.attackBoss();
  await txn.wait();

  let returnedTokenUri = await gameContract.tokenURI(1);
  console.log("Token URI:", returnedTokenUri);
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