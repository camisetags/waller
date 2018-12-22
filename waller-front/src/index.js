import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import WelcomePage from './pages/WelcomePage';
import WallPage from './pages/WallPage';

const Routes = () => (
    <Router>
      <div>
        <Route path="/" component={WelcomePage} />
        <Route path="/big-wall" component={WallPage} />
      </div>
    </Router>
);

ReactDOM.render(<Routes />, document.getElementById('root'));
