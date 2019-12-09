import React, { Component } from "react";

const domain = 'https://gateway.ipfs.io/ipfs/';

class Program extends Component {
    constructor(props) {
        super(props);
        this.state = {
            ipfsHash: ''
        };
    }

    captureIpfsHash = (event) => {
        event.preventDefault();
        this.setState({
            ipfsHash: event.target.value,
        });
    }

    onGetIpfsHash = (event) => {
        event.preventDefault();
        this.props.contract.methods.getIpfsHash().call().then((r) => {
            console.log(domain + r);
        });
    }

    onSetIpfsHash = (event) => {
        event.preventDefault();
        this.props.contract.methods.setIpfsHash(this.state.ipfsHash).send({ from: this.props.account }).then((r) => {
            console.log("submitted");
        });
    }

    render() {
        return (
            <React.Fragment>
                <form onSubmit={this.onGetIpfsHash}>
                    <div className="form-group">
                        <h2>Get IPFS hash for program and proving key:</h2>
                        <button type="submit" className="btn btn-primary">Submit</button>
                    </div>
                </form>
                <form onSubmit={this.onSetIpfsHash}>
                    <div className="form-group">
                        <h2>Set IPFS hash for program and proving key (only for contract's owner):</h2>
                        <input type="text" className="form-control" id="formGroupExampleInput" placeholder="IPFS Hash" onChange={this.captureIpfsHash} />
                        <button type="submit" className="btn btn-primary">Submit</button>
                    </div>
                </form>
            </React.Fragment>
        );
    }
}

export default Program;
