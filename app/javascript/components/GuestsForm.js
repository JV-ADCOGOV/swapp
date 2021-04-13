import React from "react";
import Downshift from "downshift";
import axios from "axios";

const ClientSuggestion = ({ name, date_of_birth }) => {
  return (
    <>
      {name} - - {date_of_birth}
    </>
  );
};

class ClientAutocomplete extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      clients: [],
    };
  }

  inputOnChange = (event) => {
    if (!event.target.value) {
      return;
    }
    this.fetchClients(event.target.value);
  };

  fetchClients = (term) => {
    const clientsURL = `/clients/search.json?q=${term}`;
    axios.get(clientsURL).then((response) => {
      this.setState({ clients: response.data });
    });
  };

  downshiftOnChange = (client) => this.props.onSelectClient(client);

  render() {
    return (
      <Downshift
        onChange={this.downshiftOnChange}
        itemToString={(item) => (item ? item.name : "")}
      >
        {({
          selectedItem,
          getInputProps,
          getItemProps,
          highlightedIndex,
          isOpen,
          inputValue,
          getLabelProps,
        }) => (
          <div>
            <input
              {...getInputProps({
                placeholder: "Search guest name..",
                onChange: this.inputOnChange,
              })}
            />
            {isOpen ? (
              <div className="downshift-dropdown">
                {this.state.clients
                  .filter(
                    (item) =>
                      !inputValue ||
                      item.name.toLowerCase().includes(inputValue.toLowerCase())
                  )
                  .slice(0, 10)
                  .map((item, index) => (
                    <div
                      {...getItemProps({ key: index, index, item })}
                      className="dropdown-item"
                    >
                      <ClientSuggestion {...item} />
                    </div>
                  ))}
              </div>
            ) : null}
          </div>
        )}
      </Downshift>
    );
  }
}

class GuestsForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedClients: [],
    };
  }

  onSelectClient = (client) => {
    this.setState((prevState) => ({
      selectedClients: [...prevState.selectedClients, client],
    }));
  };

  render() {
    return (
      <div>
        <h3 className="text-6xl leading-loose font-medium text-gray-900">
          Additional Guest(s)
          <p className="text-4xl text-indigo-800">
            some help text about the number of guests?
          </p>
        </h3>
        <div id="guests_container">
          <div id="guests" className="mt-16">
            {this.state.selectedClients.map((item, index) => (
              <div>
                <ClientSuggestion key={index} {...item} />
              </div>
            ))}
          </div>
          <ClientAutocomplete onSelectClient={this.onSelectClient} />
        </div>
      </div>
    );
  }
}

export default GuestsForm;
