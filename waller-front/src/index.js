import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import WelcomePage from './pages/welcome';
import WallPage from './pages/wall';
import Layout from './components/layout';
import Percentage from './pages/percentage';

const Routes = () => (
  <Router>
    <Layout>
      <Route exact path="/" component={WelcomePage} />
      <Route path="/big-wall/:wall_id" component={WallPage} />
      <Route path="/results/:wall_id" component={Percentage} />
    </Layout>
  </Router>
);

ReactDOM.render(<Routes />, document.getElementById('root'));
