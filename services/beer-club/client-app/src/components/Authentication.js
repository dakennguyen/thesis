import React, { Component } from "react";

class Authentication extends Component {
    constructor(props) {
        super(props);
        this.state = {
            jsonFile: {}
        };
    }

    captureFile = (event) => {
        event.preventDefault();
        const file = event.target.files[0];
        const reader = new window.FileReader();
        reader.readAsText(file);
        reader.onloadend = () => {
            this.setState({ jsonFile: JSON.parse(reader.result) });
        }
    };

    onSubmit = (event) => {
        event.preventDefault();
        var p = this.state.jsonFile.proof;
        var i = this.state.jsonFile.inputs;
        console.log("Validating...");
        this.props.contract.methods.authenticate(p.a, p.b, p.c, i).send({ from: this.props.account }).then((r) => {
            console.log("Done. Please reload page...");
        });
    }

    render() {
        return (
            <React.Fragment>
                <form onSubmit={this.onSubmit}>
                    <div className="form-group">
                        <h2>Submit proof.json to authorize:</h2>
                        <input type='file' onChange={this.captureFile} />
                        <button type="submit" className="btn btn-primary">Authorize</button>
                    </div>
                </form>
            </React.Fragment>
        );
    }
}

export default Authentication;
