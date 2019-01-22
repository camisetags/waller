import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import WelcomePage from './pages/Welcome';
import WallPage from './pages/Wall';
import Layout from './components/Layout';
import Percentage from './pages/Percentage';

const Routes = () => (
  <Router>
    <Layout>
      <Route exact path="/" component={WelcomePage} />
      <Route path="/big-wall" component={WallPage} />
      <Route path="/results" component={Percentage} />
    </Layout>
  </Router>
);

ReactDOM.render(<Routes />, document.getElementById('root'));
