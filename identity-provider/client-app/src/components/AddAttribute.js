import React, { Component } from "react";

class AddAttribute extends Component {
    constructor(props) {
        super(props);
        this.state = {
            attributeType: '',
            attributeValue: '',
            hash: 'Hash...',
            signature: 'Signature...',
            signedBy: 'Signed by...'
        };
    }

    captureAttributeType = (event) => {
        event.preventDefault();
        this.setState({
            attributeType: event.target.value,
            hash: 'Please fetch signature!',
            signature: 'Please fetch signature!',
            signedBy: 'Please fetch signature!'
        });
    }

    captureAttributeValue = (event) => {
        event.preventDefault();
        this.setState({
            attributeValue: event.target.value,
            hash: 'Please fetch signature!',
            signature: 'Please fetch signature!',
            signedBy: 'Please fetch signature!'
        });
    }

    onConfirm = (event) => {
        event.preventDefault();
        this.props.dnsContract.methods.getValidator(this.state.attributeType).call().then((r) => {
            fetch(r + '?data=' + this.state.attributeValue).then((result) => {
                console.log(r);
                result.json().then(data => {
                    this.setState({
                        hash: data.hash,
                        signature: data.signature,
                        signedBy: r
                    })
                });
            });
        });
    }

    onSubmit = (event) => {
        event.preventDefault();
        this.props.contract.methods.add(this.state.attributeType, this.state.hash, this.state.signature).send({ from: this.props.account }).then((r) => {
            console.log("submitted");
        });
    }

    register = (event) => {
        event.preventDefault();
        this.props.contract.methods.register.send({ from: this.props.account });
    }

    render() {
        return (
            <form onSubmit={this.onSubmit}>
                <div className="form-group">
                    <h2>Add a new attribute:</h2>
                    <input type="text" className="form-control" placeholder="Type" onChange={this.captureAttributeType} />
                    <input type="text" className="form-control" placeholder="Value" onChange={this.captureAttributeValue} />
                    <input className="form-control" type="text" placeholder={this.state.hash} readOnly />
                    <input className="form-control" type="text" placeholder={this.state.signature} readOnly />
                    <input className="form-control" type="text" placeholder={this.state.signedBy} readOnly />
                    <button type="button" className="btn btn-secondary" onClick={this.onConfirm}>Confirm</button>
                    <button type="submit" className="btn btn-primary">Submit</button>
                    <button type="button" className="btn btn-primary" onClick={this.register}>Register</button>
                </div>
            </form>
        );
    }
}

export default AddAttribute;
