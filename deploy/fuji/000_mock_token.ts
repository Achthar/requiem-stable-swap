import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { parseUnits } from 'ethers/lib/utils';
import { DeployFunction } from 'hardhat-deploy/types';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy, execute } = deployments;
  const { deployer, user } = await getNamedAccounts();

  console.log('network', network);
  console.log('deployer', deployer);
  console.log('2ndParty', user);

  const usdc = await deploy('USDC', {
    contract: 'MockERC20',
    from: deployer,
    log: true,
    args: ['USD Coin', 'USDC', 6],
  });

  const busd = await deploy('USDT', {
    contract: 'MockERC20',
    from: deployer,
    log: true,
    args: ['Tether USD', 'USDT', 6],
  });

  const dai = await deploy('DAI', {
    contract: 'MockERC20',
    from: deployer,
    log: true,
    args: ['DAI Stablecoin', 'DAI', 18],
  });


  const tusd = await deploy('TUSD', {
    contract: 'MockERC20',
    from: deployer,
    log: true,
    args: ['True USD', 'TUSD', 18],
  });

  await execute('USDC', { from: deployer, log: true }, 'mint', deployer, parseUnits('10000000', 6) );
  await execute('USDT', { from: deployer, log: true }, 'mint', deployer, parseUnits('10000000', 6) );
  await execute('DAI', { from: deployer, log: true }, 'mint', deployer, parseUnits('10000000', 18) );
  await execute('TUSD', { from: deployer, log: true }, 'mint', deployer, parseUnits('10000000', 18) );
  await execute('USDC', { from: deployer, log: true }, 'mint', user, parseUnits('10000000', 6) );
  await execute('USDT', { from: deployer, log: true }, 'mint', user, parseUnits('10000000', 6) );
  await execute('DAI', { from: deployer, log: true }, 'mint', user, parseUnits('10000000', 18) );
  await execute('TUSD', { from: deployer, log: true }, 'mint', user, parseUnits('10000000', 18) );
};

export default func;
func.tags = ['deploy_stables'];
