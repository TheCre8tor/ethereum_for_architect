// import { expect } from "chai";
import { ethers } from "hardhat";

describe("Coin Transaction", function () {
  it("Transfer coin to a merchant", async function () {
    const Coin = await ethers.getContractFactory("Coin");
    const coin = await Coin.deploy();

    await coin.deployed();

    const [owner, randomSigner] = await ethers.getSigners();

    console.log("Contract Deployed by:", owner.address);

    const mint = await coin.mint(randomSigner.address, 100000);
    await mint.wait();

    const send = await coin.send(randomSigner.address, 100000);
    await send.wait();

    const sendCoin = await coin.getBalance();
    const name = await coin.getName();
    console.log(name);
    console.log(sendCoin.toNumber());
  });
});
