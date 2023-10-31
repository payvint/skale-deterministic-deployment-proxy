# SKALE Deterministic Deployment Proxy
This is a proxy contract that can be deployed to any SKALE chain at the same address, and can then in turn deploy any contract by whitelisted(in ConfigController) deployers at a deterministic location using CREATE2.  To use, first deploy the contract using the "Steps" below, then submit a transaction `to` the address specified in `0x647a4a371397dfca08829ef628641d7330bb0f07` (or grab last known good from bottom of readme). The data should be the 32 byte 'salt' followed by your init code.

## Steps
1. Whitelist deployer address (`0xc61b4ff243a7556729a0f081b4389adf19bfe74b`) a DEPLOYER_ROLE on SKALE chain
2. Submit a tx below like this - change ENDPOINT to RPC endpoint of the SKALE chain:
```
curl -d '{"method": "eth_sendRawTransaction", "params": ["0xf9012e80a0e7d34572731aaeb00ab814061bba3f57e6fe8ec59c6571f97e8becf659f0a4af830186a08080b8c160b28061000f600039806000f350fe6040516313f44d1081523360208201526040810160405260006020826024601c850173d2002000000000000000000000000000000000d27ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa15156061578081fd5b81511515606c578081fd5b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe03601915081602082378035828234f580151560a6578182fd5b8082525050506014600cf31ba0f90146752b5820c0905eebac1f1c79c01378a12312c9ae23da7c301870644036a079e1582bdd74f38a5a1797718bfd21c7ef8d6c736b2ae738de917baa96a476e7"], "id": 1337}' -l ENDPOINT
```

## Explanation
This repository contains a simple contract that can deploy other contracts with a deterministic address on any SKALE chain using CREATE2 and check the DEPLOYER permission of the sender.  The CREATE2 call will deploy a contract (like CREATE opcode) but instead of the address being `keccak256(rlp([deployer_address, nonce]))` it instead uses the hash of the contract's bytecode and a salt.  This means that a given deployer address will deploy the same code to the same address no matter _when_ or _where_ they issue the deployment.  The deployer is deployed with a one-time-use-account, so no matter what chain the deployer is on, its address will always be the same.  This means the only variables in determining the address of your contract are its bytecode hash and the provided salt.

Between the use of CREATE2 opcode and the one-time-use-account for the deployer, we can ensure that a given contract will exist at the _exact_ same address on every SKALE chain, but without having to use the same gas pricing or limits every time.

Only whitelisted deployers would be able to deploy via CREATE2, otherwise deployment tx would be reverted
----

## Latest Outputs

It is known to have been deployed to: [SKALE Chaos test-net](https://staging-fast-active-bellatrix.explorer.staging-v3.skalenodes.com/tx/0x53f0415b18d337d6b384d98d6d77e4354f8834424d3c3908bde176252f17ef74/internal-transactions)

### Proxy Address
```
0x647a4a371397dfca08829ef628641d7330bb0f07
```

### Deployment Transaction
```
0xf9012e80a0e7d34572731aaeb00ab814061bba3f57e6fe8ec59c6571f97e8becf659f0a4af830186a08080b8c160b28061000f600039806000f350fe6040516313f44d1081523360208201526040810160405260006020826024601c850173d2002000000000000000000000000000000000d27ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa15156061578081fd5b81511515606c578081fd5b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe03601915081602082378035828234f580151560a6578182fd5b8082525050506014600cf31ba0f90146752b5820c0905eebac1f1c79c01378a12312c9ae23da7c301870644036a079e1582bdd74f38a5a1797718bfd21c7ef8d6c736b2ae738de917baa96a476e7
```

### Deployment Signer Address
```
0xc61b4ff243a7556729a0f081b4389adf19bfe74b
```

### Deployment Gas Price
```
Defined by PoW:
0xe7d34572731aaeb00ab814061bba3f57e6fe8ec59c6571f97e8becf659f0a4af
```

### Deployment Gas Limit
```
100000
```
