import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';
import { writeFileSync } from 'fs';
import { parseEther } from 'ethers/lib/utils';
import { artifacts } from 'hardhat';

// npx hardhat deploy --network bsc-testnet --tags deploy_BSCT --reset

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy, execute } = deployments;

  const { deployer } = await getNamedAccounts();

  const requiemToken = await deploy('RequiemToken', {
    from: deployer,
    args: ["Requiem Token", "REQT"],
    log: true,
  });

  const fundDistributor = await deploy('FundDistributor',
  {
    from:deployer,
    args:[]
  })

  const requiemChef = await deploy('RequiemChef',
    {
      from: deployer,
      args: [
        requiemToken.address,
        fundDistributor.address,
      ],
      log: true,

    });

  const contracts = {
    "RequiemToken": requiemToken.address,
    "FundDistributor": fundDistributor.address,
    "RequiemChef": requiemChef.address,
  }

  writeFileSync('deployments/' + network.name + '/addresses/farms.json', JSON.stringify(contracts));
};

export default func;
func.tags = ['deploy_fuji'];
