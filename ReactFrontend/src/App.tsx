import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, Link, useNavigate } from 'react-router-dom';
import ClaimsList from './claims/ClaimsList';
import ClaimForm from './claims/ClaimForm';
import ClaimDetails from './claims/ClaimDetails';
import Login from './claims/Login';
import PrivateRoute from './claims/PrivateRoute';
import { AuthProvider, useAuth } from './claims/auth';
import { CssBaseline, Container, AppBar, Toolbar, Button, Typography, Box, CircularProgress, Snackbar, Alert } from '@mui/material';

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
    <Route path="*" element={<Alert severity="error">Page not found</Alert>} />
  </Routes>
);

import useVersionCheck from './useVersionCheck';

const App: React.FC = () => {
  useVersionCheck();
  // Example: global loading and error state (replace with real state management as needed)
  const [loading, setLoading] = React.useState(false);
  const [error, setError] = React.useState<string | null>(null);

  return (
    <AuthProvider>
      <Router>
        <CssBaseline />
        <NavBar />
        <Container maxWidth="lg">
          {loading && <Box display="flex" justifyContent="center" mt={4}><CircularProgress /></Box>}
          {error && <Snackbar open autoHideDuration={6000} onClose={() => setError(null)}><Alert severity="error">{error}</Alert></Snackbar>}
          <Box mt={4}>
            <AppRoutes />
          </Box>
        </Container>
      </Router>
    </AuthProvider>
  );
};

export default App;
