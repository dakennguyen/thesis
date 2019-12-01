import React, { Component } from "react";

class Data extends Component {
    getData = (event) => {
        event.preventDefault();
        console.log("Submitting...");
        this.props.contract.methods.getData(this.props.account).call().then((r) => {
            console.log(r);
        })
    }

    render() {
        return (
            <React.Fragment>
                <form onSubmit={this.onSubmit}>
                    <div className="form-group">
                        <h2>Get client's data:</h2>
                        <button type="button" className="btn btn-primary" onClick={this.getData}>Get</button>
                    </div>
                </form>
            </React.Fragment>
        );
    }
}

export default Data;
