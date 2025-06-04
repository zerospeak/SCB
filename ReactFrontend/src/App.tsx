import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, Link, useNavigate } from 'react-router-dom';
import ClaimsList from './claims/ClaimsList';
import ClaimForm from './claims/ClaimForm';
import ClaimDetails from './claims/ClaimDetails';
import Login from './claims/Login';
import PrivateRoute from './claims/PrivateRoute';
import { AuthProvider, useAuth } from './claims/auth';
import { CssBaseline, Container, AppBar, Toolbar, Button, Typography, Box } from '@mui/material';

const NavBar: React.FC = () => {
  const { isAuthenticated, logout } = useAuth();
  const navigate = useNavigate();
  return (
    <AppBar position="static">
      <Toolbar>
        <Typography variant="h6" sx={{ flexGrow: 1, cursor: 'pointer' }} onClick={() => navigate('/claims')}>
          HealthGuard
        </Typography>
        <Button color="inherit" component={Link} to="/claims">Claims</Button>
        <Button color="inherit" component={Link} to="/claims/new">New Claim</Button>
        {!isAuthenticated && <Button color="inherit" component={Link} to="/login">Login</Button>}
        {isAuthenticated && <Button color="inherit" onClick={() => { logout(); navigate('/login'); }}>Logout</Button>}
      </Toolbar>
    </AppBar>
  );
};

const AppRoutes: React.FC = () => (
  <Routes>
    <Route path="/" element={<Navigate to="/claims" replace />} />
    <Route path="/login" element={<Login />} />
    <Route path="/claims" element={<PrivateRoute><ClaimsList /></PrivateRoute>} />
    <Route path="/claims/new" element={<PrivateRoute><ClaimForm /></PrivateRoute>} />
    <Route path="/claims/edit/:id" element={<PrivateRoute><ClaimForm /></PrivateRoute>} />
    <Route path="/claims/:id" element={<PrivateRoute><ClaimDetails /></PrivateRoute>} />
  </Routes>
);

const App: React.FC = () => (
  <AuthProvider>
    <Router>
      <CssBaseline />
      <NavBar />
      <Container maxWidth="lg">
        <Box mt={4}>
          <AppRoutes />
        </Box>
      </Container>
    </Router>
  </AuthProvider>
);

export default App;
