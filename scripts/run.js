const main = async () => {
  //Compile our contract
  const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
  //Deploy our contract
  const gameContract = await gameContractFactory.deploy(
    ["Jack Black", "Jack White", "Samurai Jack"],
    ["https://imgur.com/gallery/ylOYBpT",
    "https://imgur.com/gallery/1r3XKWC",
    "https://imgur.com/t/samurai_jack/uSZ9ckg"],
    [350, 200, 100],
    [100, 150, 225]
  );
  //wait for the resolution of the deploy method
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  txn = await gameContract.mintJackNFT(2);
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