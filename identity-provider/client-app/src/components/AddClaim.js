import React, { Component } from "react";

class AddClaim extends Component {
    constructor(props) {
        super(props);
        this.state = {
            claimType: '',
            claimValue: '',
            signature: ''
        };
    }

    captureClaimType = (event) => {
        event.preventDefault();
        this.setState({ claimType: event.target.value });
    }

    captureClaimValue = (event) => {
        event.preventDefault();
        this.setState({ claimValue: event.target.value });
    }

    captureSignature = (event) => {
        event.preventDefault();
        this.setState({ signature: event.target.value });
    }

    onSubmit = (event) => {
        event.preventDefault();
        this.props.contract.methods.addAttribute(this.state.claimType, this.state.claimValue, this.state.signature).send({ from: this.props.account }).then((r) => {
            console.log("submitted");
        });
    }

    register = (event) => {
        event.preventDefault();
        this.props.contract.methods.register.send({ from: this.props.account });
    }

    getAllClaims = (event) => {
        event.preventDefault();
        this.props.contract.methods.getAllAttributes.call({ from: this.props.account }).then((r) => {
            console.log(r);
        })
        //this.props.contract.methods.getAllClaims(this.props.account).call({ from: this.props.account }).then((r) => {
        //console.log(r);
        //})
    }

    render() {
        return (
            <form onSubmit={this.onSubmit}>
                <div className="form-group">
                    <label>Add a new claim:</label>
                    <input type="text" className="form-control" id="formGroupExampleInput" placeholder="Type" onChange={this.captureClaimType} />
                    <input type="text" className="form-control" id="formGroupExampleInput" placeholder="Value" onChange={this.captureClaimValue} />
                    <input type="text" className="form-control" id="formGroupExampleInput" placeholder="Signature" onChange={this.captureSignature} />
                    <button type="submit" className="btn btn-primary">Submit</button>
                    <button type="button" className="btn btn-primary" onClick={this.getAllClaims}>Get all Claims</button>
                    <button type="button" className="btn btn-primary" onClick={this.register}>Register</button>
                </div>
            </form>
        );
    }
}

export default AddClaim;
