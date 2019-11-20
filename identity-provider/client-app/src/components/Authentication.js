import React, { Component } from "react";

class Authentication extends Component {
    constructor(props) {
        super(props);
        this.state = {
            address: ''
        };
    }

    captureAddress = (event) => {
        event.preventDefault();
        this.setState({ address: event.target.value });
    }

    getAllowedClaims = (event) => {
        event.preventDefault();
        this.props.contract.methods.getAllowedClaims(this.state.address).call().then((r) => {
            console.log(r);
        })
    }

    onSubmit = (event) => {
        event.preventDefault();
        this.props.contract.methods.sendData(this.state.address).send({ from: this.props.account }).then((r) => {
            console.log("submitted");
        });
    }

    render() {
        return (
            <React.Fragment>
                <form onSubmit={this.onSubmit}>
                    <div className="form-group">
                        <label>Send data to service:</label>
                        <input type="text" className="form-control" id="formGroupExampleInput" placeholder="Address" onChange={this.captureAddress} />
                        <button type="submit" className="btn btn-primary">Submit</button>
                        <button type="button" className="btn btn-primary" onClick={this.getAllowedClaims}>Get service's allowed claims</button>
                    </div>
                </form>
            </React.Fragment>
        );
    }
}

export default Authentication;
