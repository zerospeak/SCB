import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { getClaim } from './claimsApi';
import { Claim } from './types';
import { Box, Button, CircularProgress, Paper, Toolbar, Typography, Grid } from '@mui/material';

const ClaimDetails: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [claim, setClaim] = useState<Claim | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const navigate = useNavigate();

  useEffect(() => {
    if (id) {
      setLoading(true);
      getClaim(Number(id)).then(setClaim).finally(() => setLoading(false));
    }
  }, [id]);

  if (loading) return <CircularProgress />;
  if (!claim) return <Paper sx={{ p: 3, mt: 4 }}>Claim not found.</Paper>;

  return (
    <Box maxWidth={700} mx="auto" mt={4}>
      <Paper sx={{ p: 3 }}>
        <Toolbar>
          <Typography variant="h6">Claim Details</Typography>
        </Toolbar>
        <Grid container spacing={2}>
          <Grid item xs={4}><strong>Claim Number</strong></Grid>
          <Grid item xs={8}>{claim.claimNumber}</Grid>
          <Grid item xs={4}><strong>Policy Holder</strong></Grid>
          <Grid item xs={8}>{claim.policyHolder}</Grid>
          <Grid item xs={4}><strong>Date</strong></Grid>
          <Grid item xs={8}>{new Date(claim.date).toLocaleDateString()}</Grid>
          <Grid item xs={4}><strong>Status</strong></Grid>
          <Grid item xs={8}>{claim.status}</Grid>
          <Grid item xs={4}><strong>Amount</strong></Grid>
          <Grid item xs={8}>{claim.amount.toLocaleString(undefined, { style: 'currency', currency: 'USD' })}</Grid>
        </Grid>
        <Box display="flex" justifyContent="flex-end" gap={2} mt={3}>
          <Button variant="outlined" onClick={() => navigate('/claims')}>Back</Button>
          <Button variant="contained" color="primary" onClick={() => navigate(`/claims/edit/${claim.id}`)}>Edit</Button>
        </Box>
      </Paper>
    </Box>
  );
};

export default ClaimDetails;
