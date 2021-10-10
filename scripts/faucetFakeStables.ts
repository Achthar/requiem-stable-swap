// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from 'hardhat';
import { Contract, ContractFactory } from 'ethers';

import * as DAI from '../deployments/fuji/DAI.json';
import * as USDT from '../deployments/fuji/USDT.json';

async function main(): Promise<void> {
    // Hardhat always runs the compile task when running scripts through it.
    // If this runs in a standalone fashion you may want to call compile manually
    // to make sure everything is compiled
    // await run("compile");
    // We get the contract to deploy

    const dai = await (
        await ethers.getContractFactory('DAI')
    ).attach("0x66960440491bCc68BD30B2b0B08fF9e7aB3F9078");
    const usdt = await (
        await ethers.getContractFactory('USDT')
    ).attach("0x0bE04001Ad4725c697b6c6bD8Bc23d9848992CA0");

    try {
        await dai['setMinter(address,uint256)']('0x10E38dFfFCfdBaaf590D5A9958B01C9cfcF6A63B', '1000000000000000000000000');
        await usdt['setMinter(address,uint256)']('0x10E38dFfFCfdBaaf590D5A9958B01C9cfcF6A63B', '1000000000000000000000000');
    } catch (e) { 
        console.log(e) 
    }

    try {
        await dai['mint_natural(address,uint256)']('0x10E38dFfFCfdBaaf590D5A9958B01C9cfcF6A63B', 1000000);
        await usdt['mint_natural(address,uint256)']('0x10E38dFfFCfdBaaf590D5A9958B01C9cfcF6A63B', 1000000);

    } catch (e) {
        console.log(e)
    }
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error: Error) => {
        console.error(error);
        process.exit(1);
    });
