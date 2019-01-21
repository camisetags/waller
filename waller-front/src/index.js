import React, { Fragment } from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import WelcomePage from './pages/WelcomePage';

const Routes = () => (
  <Router>
    <Fragment>
      <Route exact path="/" component={WelcomePage} />
    </Fragment>
  </Router>
);

ReactDOM.render(<Routes />, document.getElementById('root'));
