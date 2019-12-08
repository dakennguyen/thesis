import React, { Component } from "react";

const ipfsClient = require('ipfs-http-client');
const ipfs = ipfsClient({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });
const domain = 'https://ipfs.infura.io/ipfs/';

class UploadProgram extends Component {
    constructor(props) {
        super(props);
        this.state = {
            buffer: null,
            ipfsHash: ''
        };
    }

    captureFile = (event) => {
        event.preventDefault();

        // Process file for IPFS...
        const file = event.target.files[0];
        const reader = new window.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onloadend = () => {
            this.setState({ buffer: Buffer(reader.result) });
        }
    };

    onSubmit = (event) => {
        event.preventDefault();
        console.log("Submitting the form...");
        ipfs.add(this.state.buffer, (error, result) => {
            console.log(result);
            const ipfsHash = result[0].hash;
            this.setState({ ipfsHash });
            console.log(domain + ipfsHash);
            if (error) {
                console.error(error);
                return;
            }

            //this.state.contract.methods.set(ipfsHash).send({ from: this.state.account }).then((r) => {
            //this.setState({ ipfsHash });
            //});
        });
    }

    render() {
        return (
            <React.Fragment>
                <form onSubmit={this.onSubmit}>
                    <div className="form-group">
                        <h2>Upload program (only for contract's owner):</h2>
                        <input type='file' onChange={this.captureFile} />
                        <button type="submit" className="btn btn-primary">Submit</button>
                    </div>
                </form>
            </React.Fragment>
        );
    }
}

export default UploadProgram;
