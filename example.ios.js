/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var { NativeModules } = React;
var { RNSelectContactPhone } = NativeModules;

var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
} = React;

var testComp = React.createClass({
  componentDidMount() {
    this._selectPhone();
  },
  async _selectPhone() {
    console.log('in select phone');
    try {
      let value = await RNSelectContactPhone.selectPhone(true);
      console.log('Phone: ' + value);
    } catch (error) {
      console.log('Error: ' + error.message);
    }
  },
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Select Phone - View Xcode Log
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('testComp', () => testComp);
