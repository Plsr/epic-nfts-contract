const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT')
  const nftContract = await nftContractFactory.deploy()
  await nftContract.deployed()
  console.log("Deployed contract to: ", nftContract.address)

  let txn = await nftContract.makeEpicNFT()
  await txn.wait()
  console.log("Minted NFT #1")

  txn = await nftContract.makeEpicNFT()
  await txn.wait()
  console.log("Minted NFT #2")
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()