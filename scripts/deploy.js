async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const RPS = await ethers.getContractFactory("RPSGame");
    const rps = await RPS.deploy();

    console.log("Contract address:", rps.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });