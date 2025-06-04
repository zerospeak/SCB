import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, Link } from 'react-router-dom';
import ClaimsList from './claims/ClaimsList';
import ClaimForm from './claims/ClaimForm';
import ClaimDetails from './claims/ClaimDetails';
import Login from './claims/Login';

function App() {
  return (
    <Router>
      <div style={{ fontFamily: 'Arial, sans-serif', padding: 40 }}>
        <nav style={{ marginBottom: 20 }}>
          <Link to="/claims" style={{ marginRight: 10 }}>Claims</Link>
          <Link to="/claims/new" style={{ marginRight: 10 }}>New Claim</Link>
          <Link to="/login">Login</Link>
        </nav>
        <Routes>
          <Route path="/" element={<Navigate to="/claims" replace />} />
          <Route path="/claims" element={<ClaimsList />} />
          <Route path="/claims/new" element={<ClaimForm />} />
          <Route path="/claims/edit/:id" element={<ClaimForm />} />
          <Route path="/claims/:id" element={<ClaimDetails />} />
          <Route path="/login" element={<Login />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
