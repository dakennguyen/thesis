import React, { Component } from "react";

class Authentication extends Component {
    constructor(props) {
        super(props);
        this.state = {
            allowedAttributes: 'age'
        };
    }

    captureAllowedAttributes = (event) => {
        event.preventDefault();
        this.setState({ allowedAttributes: event.target.value });
    }

    getAllowedClaims = (event) => {
        event.preventDefault();
        this.props.contract.methods.getAllowedAttributes(this.props.address).call().then((r) => {
            console.log(r);
        })
    }

    onSubmit = (event) => {
        event.preventDefault();
        console.log(this.state.address);
        console.log(this.state.allowedAttributes);
        console.log(this.props.account);
        this.props.contract.methods.sendData(this.props.address, this.state.allowedAttributes).send({ from: this.props.account }).then((r) => {
            console.log("submitted");
        });
    }

    render() {
        return (
            <React.Fragment>
                <form onSubmit={this.onSubmit}>
                    <div className="form-group">
                        <h2>Send data to service:</h2>
                        <input className="form-control" type="text" placeholder={this.props.address} readOnly />
                        <input type="text" className="form-control" id="formGroupExampleInput" placeholder={this.state.allowedAttributes} onChange={this.captureAllowedAttributes} />
                        <button type="submit" className="btn btn-primary">Submit</button>
                        <button type="button" className="btn btn-primary" onClick={this.getAllowedClaims}>Get service's allowed claims</button>
                    </div>
                </form>
            </React.Fragment>
        );
    }
}

export default Authentication;
