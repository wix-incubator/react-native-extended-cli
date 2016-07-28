import {shallow} from 'enzyme';
const React = require('react-native-mock');

describe('Demo App', () => {

  let DemoApp;
  beforeEach(() => {
    DemoApp = require('proxyquire').noCallThru()('../../demo-app.component', {
      'react-native': React
    }).default;
  });

  it('shows an empty inbox', () => {
    const uut = shallow(<DemoApp/>);
    expect(uut.find('Text').props().children).toEqual('Hello World');
  });
});
