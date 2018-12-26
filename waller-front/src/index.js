import React, { Fragment } from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import WelcomePage from './pages/WelcomePage';
import WallPage from './pages/WallPage';

const Routes = () => (
  <Router>
    <Fragment>
      <Route exact path="/" component={WelcomePage} />
      <Route path="/big-wall" component={WallPage} />
    </Fragment>
  </Router>
);

ReactDOM.render(<Routes />, document.getElementById('root'));
