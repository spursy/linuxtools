'use strict';
const Web3 = require('web3');
const rpcurl = 'http://localhost:3002';


const Init = async function() {
  try {
    let web3;
    if (typeof web3 !== 'undefined') {
      web3 = new Web3(web3.currentProvider);
    } else {
      web3 = new Web3(new Web3.providers.HttpProvider(rpcurl));
    }
    const balance = await web3.eth.getBalance('0x3985188E4a4888b0FA9AF1E544729d2bB4d96Fd2');

    console.log(`The block number is >>> > > ${balance}.`);


    // const web3 = new Web3(
    //     new Web3.providers.HttpProvider('http://localhost:3002')
    // );
    //  //Verify connection is successful
    // web3.eth.net.isListening()
    //     .then(() => console.log('is connected'))
    //     .catch(e => console.log('Wow. Something went wrong'));
  } catch (error) {
    console.log(`${error.stack}`);
  }
};

Init();
