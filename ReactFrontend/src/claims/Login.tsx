import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from './auth';
import { Box, Button, Paper, TextField, Toolbar, Typography, CircularProgress, Divider, Snackbar, Alert } from '@mui/material';
import LoginIcon from '@mui/icons-material/Login';

const Login: React.FC = () => {
  const { login } = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [success, setSuccess] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSubmitting(true);
    const ok = await login(username, password);
    setSubmitting(false);
    if (ok) {
      setSuccess(true);
      setTimeout(() => navigate('/claims'), 1000);
    } else {
      setError('Invalid username or password.');
    }
  };

  return (
    <Box maxWidth={400} mx="auto" mt={8}>
      <Paper sx={{ p: 4 }} elevation={4}>
        <Toolbar sx={{ justifyContent: 'center', mb: 2 }}>
          <Typography variant="h5" fontWeight={600}>Sign In</Typography>
        </Toolbar>
        <Divider sx={{ mb: 2 }} />
        <form onSubmit={handleSubmit} noValidate autoComplete="off">
          <TextField
            label="Username"
            name="username"
            value={username}
            onChange={e => setUsername(e.target.value)}
            fullWidth
            margin="normal"
            required
            inputProps={{ 'aria-label': 'Username' }}
            autoFocus
          />
          <TextField
            label="Password"
            name="password"
            type="password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            fullWidth
            margin="normal"
            required
            inputProps={{ 'aria-label': 'Password' }}
          />
          {error && <Alert severity="error" sx={{ mt: 2 }}>{error}</Alert>}
          <Box display="flex" justifyContent="flex-end" gap={2} mt={3}>
            <Button
              variant="contained"
              color="primary"
              type="submit"
              disabled={submitting}
              startIcon={<LoginIcon />}
              size="large"
              sx={{ minWidth: 120 }}
            >
              {submitting ? <CircularProgress size={24} color="inherit" /> : 'Login'}
            </Button>
          </Box>
        </form>
        <Snackbar open={success} autoHideDuration={1000} onClose={() => setSuccess(false)} anchorOrigin={{ vertical: 'top', horizontal: 'center' }}>
          <Alert severity="success" sx={{ width: '100%' }}>
            Login successful!
          </Alert>
        </Snackbar>
      </Paper>
    </Box>
  );
};

export default Login;
