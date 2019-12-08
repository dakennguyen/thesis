import React, { Component } from 'react';
import './App.css';
import Web3 from 'web3';
import Idp from './abis/Idp.json';
import Dns from './abis/Dns.json';
import AddAttribute from './components/AddAttribute.js';
import GetData from './components/GetData.js';

class App extends Component {
    async UNSAFE_componentWillMount() {
        document.title = 'Identity Provider';
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
            console.log('IDP: ' + address);
            const idpContract = new web3.eth.Contract(abi, address);
            const dnsContract = new web3.eth.Contract(Dns.abi, Dns.networks[networkId].address);
            console.log('DNS: ' + Dns.networks[networkId].address);
            this.setState({ idpContract, dnsContract });
            idpContract.methods.getRegistered().call({ from: this.state.account }).then((r) => {
                this.setState({ registered: ((r == null) ? 'false' : r.toString()) })
            });
        } else {
            window.alert('Smart contract not deployed to detected network');
        }
        window.ethereum.on('accountsChanged', function (accounts) {
            window.location.reload();
        });
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
            idpContract: null,
            dnsContract: null,
            registered: '',
        };
    }

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
                        Identity Provider
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
                                <AddAttribute contract={this.state.idpContract} dnsContract={this.state.dnsContract} account={this.state.account} />
                                <GetData contract={this.state.idpContract} account={this.state.account} />
                            </div>
                        </main>
                    </div>
                </div>
            </div>
        );
    }
}

export default App;
