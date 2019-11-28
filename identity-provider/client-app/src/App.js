import React, { Component } from 'react';
import './App.css';
import Web3 from 'web3';
import Idp from './abis/Idp.json';
import AddClaim from './components/AddClaim.js';
import Authentication from './components/Authentication.js';

//const ipfsClient = require('ipfs-http-client');
//const ipfs = ipfsClient({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });
//const domain = 'ipfs.infura.io';

class App extends Component {
    async UNSAFE_componentWillMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    async loadBlockchainData() {
        const web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        this.setState({ account: accounts[0] });
        const networkId = await web3.eth.net.getId();
        const networkData = Idp.networks[networkId];
        if (networkData) {
            const abi = Idp.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            this.setState({ contract });
            contract.methods.getRegistered().call({ from: this.state.account }).then((r) => {
                this.setState({ registered: r.toString() })
            });
        } else {
            window.alert('Smart contract not deployed to detected network');
        }
        window.ethereum.on('accountsChanged', function (accounts) {
            window.location.reload();
        })
    }

    async loadWeb3() {
        if (window.ethereum) {
            window.web3 = new Web3(window.ethereum);
            await window.ethereum.enable();
        } if (window.web3) {
            window.web3 = new Web3(window.web3.currentProvider);
        } else {
            window.alert('Please use metamask!');
        }
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            buffer: null,
            contract: null,
            registered: '',
        };
    }


    //captureText = (event) => {
    //event.preventDefault();
    //const test = event.target.value;
    //this.setState({ test });
    //}

    //onSubmit = (event) => {
    //event.preventDefault();
    //console.log("Submitting...");
    //var buf = Buffer.from(this.state.test, 'utf8');
    //ipfs.add(buf, (error, result) => {
    //console.log('ipfs result', result);
    //const test = result[0].hash;
    //this.setState({ test });
    //if (error) {
    //console.error(error);
    //return;
    //}

    //// Step 2: store file on blockchain...
    //this.state.contract.methods.set(test).send({ from: this.state.account }).then((r) => {
    //this.setState({ test });
    //});
    //});
    //}

    render() {
        return (
            <div>
                <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
                    <a
                        className="navbar-brand col-sm-3 col-md-2 mr-0"
                        href="http://www.dappuniversity.com/bootcamp"
                        target="_blank"
                        rel="noopener noreferrer"
                    >
                        Meme of the Day
                    </a>
                    <ul className="navbar-nav px-3">
                        <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                            <small className="text-white">{this.state.account}</small>
                        </li>
                        <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                            <small className="text-white">Registered = {this.state.registered}</small>
                        </li>
                    </ul>
                </nav>
                <div className="container-fluid mt-5">
                    <div className="row">
                        <main role="main" className="col-lg-12 d-flex text-center">
                            <div className="content mr-auto ml-auto">
                                <h2>Change meme</h2>
                                {/*
                                <p>{`https://${domain}/ipfs/${this.state.test}`}</p>
                                <form onSubmit={this.onSubmit}>
                                    <div className="form-group">
                                        <label>Set test value:</label>
                                        <input type="text" className="form-control" id="formGroupExampleInput" placeholder="Example input" onChange={this.captureText} />
                                        <input type='submit' />
                                    </div>
                                </form>
                                */}
                                <AddClaim contract={this.state.contract} account={this.state.account} />
                                <Authentication contract={this.state.contract} account={this.state.account} />
                            </div>
                        </main>
                    </div>
                </div>
            </div>
        );
    }
}

export default App;
