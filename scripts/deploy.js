const bre = require("@nomiclabs/buidler");

async function main() {
  const Mstable = await ethers.getContractFactory("MStable");
  const mstable = await Mstable.deploy(
    "0x4E1000616990D83e56f4b5fC6CC8602DcfD20459",
    "0x300e56938454A4d8005B2e84eefFca002B3a24Bc"
  );

  await mstable.deployed();
  console.log("Mstable deployed to:", mstable.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
