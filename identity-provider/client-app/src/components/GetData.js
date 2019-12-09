import React, { Component } from "react";

class GetData extends Component {
    constructor(props) {
        super(props);
        this.state = {
            attributeType: '',
        };
    }

    captureAttributeType = (event) => {
        event.preventDefault();
        this.setState({
            attributeType: event.target.value,
        });
    }

    onSubmit = (event) => {
        event.preventDefault();
        this.props.contract.methods.getData(this.props.account, this.state.attributeType).call().then((r) => {
            console.log("Hash: " + r[0]);
            console.log("Signature: " + r[1]);
        })
    }

    render() {
        return (
            <form onSubmit={this.onSubmit}>
                <div className="form-group">
                    <h2>Get data by type:</h2>
                    <input type="text" className="form-control" id="formGroupExampleInput" placeholder="Type" onChange={this.captureAttributeType} />
                    <button type="submit" className="btn btn-primary">Submit</button>
                </div>
            </form>
        );
    }
}

export default GetData;
