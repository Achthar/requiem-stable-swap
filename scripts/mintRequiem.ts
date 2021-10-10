// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from 'hardhat';
import { Contract, ContractFactory } from 'ethers';

async function main(): Promise<void> {
    // Hardhat always runs the compile task when running scripts through it.
    // If this runs in a standalone fashion you may want to call compile manually
    // to make sure everything is compiled
    // await run("compile");
    // We get the contract to deploy

    const requt = await (
        await ethers.getContractFactory('RequiemToken')
    ).attach("0x78e418385153177cB1c49e58eAB5997192998bf7");

    try {
        await requt['setMinter(address,uint256)']('0x10E38dFfFCfdBaaf590D5A9958B01C9cfcF6A63B', '1000000000000000000000000');
    } catch (e) {
        console.log(e)
    }

    try {
        await requt['mint(address,uint256)']('0x10E38dFfFCfdBaaf590D5A9958B01C9cfcF6A63B', '1000000000000000000000000');

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
