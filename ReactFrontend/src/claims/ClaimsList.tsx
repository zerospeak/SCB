import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getClaims, deleteClaim } from './claimsApi';
import { Claim } from './types';
import {
  Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper, Button, Toolbar, Typography, CircularProgress, Box, IconButton, Tooltip, Snackbar, Alert, Divider
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import VisibilityIcon from '@mui/icons-material/Visibility';

const ClaimsList: React.FC = () => {
  const [claims, setClaims] = useState<Claim[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [success, setSuccess] = useState(false);
  const navigate = useNavigate();

  const loadClaims = async () => {
    setLoading(true);
    setClaims(await getClaims());
    setLoading(false);
  };

  useEffect(() => {
    loadClaims();
  }, []);

  const handleDelete = async (id?: number) => {
    if (!id) return;
    await deleteClaim(id);
    setSuccess(true);
    loadClaims();
  };

  return (
    <Box maxWidth={1100} mx="auto" mt={4}>
      <Paper sx={{ p: 3 }} elevation={4}>
        <Toolbar sx={{ justifyContent: 'space-between', mb: 2 }}>
          <Typography variant="h5" fontWeight={600}>Claims</Typography>
          <Button variant="contained" color="primary" startIcon={<AddIcon />} onClick={() => navigate('/claims/new')}>
            New Claim
          </Button>
        </Toolbar>
        <Divider sx={{ mb: 2 }} />
        {loading ? (
          <Box display="flex" justifyContent="center" alignItems="center" minHeight="30vh"><CircularProgress /></Box>
        ) : claims.length === 0 ? (
          <Paper sx={{ p: 2, mt: 2, textAlign: 'center' }}>No claims found.</Paper>
        ) : (
          <TableContainer component={Paper} sx={{ mt: 2 }}>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Claim #</TableCell>
                  <TableCell>Policy Holder</TableCell>
                  <TableCell>Date</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell align="right">Amount</TableCell>
                  <TableCell align="center">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {claims.map((claim) => (
                  <TableRow key={claim.id} hover>
                    <TableCell>{claim.claimNumber}</TableCell>
                    <TableCell>{claim.policyHolder}</TableCell>
                    <TableCell>{new Date(claim.date).toLocaleDateString()}</TableCell>
                    <TableCell>{claim.status}</TableCell>
                    <TableCell align="right">{claim.amount.toLocaleString(undefined, { style: 'currency', currency: 'USD' })}</TableCell>
                    <TableCell align="center">
                      <Tooltip title="View"><IconButton color="primary" onClick={() => navigate(`/claims/${claim.id}`)}><VisibilityIcon /></IconButton></Tooltip>
                      <Tooltip title="Edit"><IconButton color="info" onClick={() => navigate(`/claims/edit/${claim.id}`)}><EditIcon /></IconButton></Tooltip>
                      <Tooltip title="Delete"><IconButton color="error" onClick={() => handleDelete(claim.id)}><DeleteIcon /></IconButton></Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        )}
        <Snackbar open={success} autoHideDuration={1200} onClose={() => setSuccess(false)} anchorOrigin={{ vertical: 'top', horizontal: 'center' }}>
          <Alert severity="success" sx={{ width: '100%' }}>
            Claim deleted successfully!
          </Alert>
        </Snackbar>
      </Paper>
    </Box>
  );
};

export default ClaimsList;
