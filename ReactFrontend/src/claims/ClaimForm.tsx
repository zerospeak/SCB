import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Claim } from './types';
import { createClaim, getClaim, updateClaim } from './claimsApi';
import {
  Box, Button, CircularProgress, Paper, TextField, Toolbar, Typography, Divider, Snackbar, Alert
} from '@mui/material';
import SaveIcon from '@mui/icons-material/Save';
import CancelIcon from '@mui/icons-material/Cancel';

const emptyClaim: Claim = {
  claimNumber: '',
  policyHolder: '',
  date: '',
  status: '',
  amount: 0
};

const ClaimForm: React.FC = () => {
  const { id } = useParams<{ id?: string }>();
  const isEdit = Boolean(id);
  const [claim, setClaim] = useState<Claim>(emptyClaim);
  const [loading, setLoading] = useState<boolean>(!!id);
  const [submitting, setSubmitting] = useState<boolean>(false);
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const [success, setSuccess] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    if (id) {
      setLoading(true);
      getClaim(Number(id)).then(setClaim).finally(() => setLoading(false));
    }
  }, [id]);

  const validate = (): boolean => {
    const errs: { [key: string]: string } = {};
    if (!claim.claimNumber) errs.claimNumber = 'Required';
    if (!claim.policyHolder) errs.policyHolder = 'Required';
    if (!claim.date) errs.date = 'Required';
    if (!claim.status) errs.status = 'Required';
    if (claim.amount < 0) errs.amount = 'Must be positive';
    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setClaim({ ...claim, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    setSubmitting(true);
    if (isEdit && id) {
      await updateClaim(Number(id), claim);
    } else {
      await createClaim(claim);
    }
    setSubmitting(false);
    setSuccess(true);
    setTimeout(() => navigate('/claims'), 1200);
  };

  if (loading) return <Box display="flex" justifyContent="center" alignItems="center" minHeight="40vh"><CircularProgress /></Box>;

  return (
    <Box maxWidth={700} mx="auto" mt={4}>
      <Paper sx={{ p: 3 }} elevation={4}>
        <Toolbar sx={{ justifyContent: 'center', mb: 2 }}>
          <Typography variant="h5" fontWeight={600}>{isEdit ? 'Edit Claim' : 'New Claim'}</Typography>
        </Toolbar>
        <Divider sx={{ mb: 2 }} />
        <form onSubmit={handleSubmit} noValidate autoComplete="off">
          <Box display="flex" flexDirection={{ xs: 'column', sm: 'row' }} gap={2}>
            <TextField
              label="Claim Number"
              name="claimNumber"
              value={claim.claimNumber}
              onChange={handleChange}
              error={!!errors.claimNumber}
              helperText={errors.claimNumber}
              fullWidth
              required
              inputProps={{ 'aria-label': 'Claim Number' }}
            />
            <TextField
              label="Policy Holder"
              name="policyHolder"
              value={claim.policyHolder}
              onChange={handleChange}
              error={!!errors.policyHolder}
              helperText={errors.policyHolder}
              fullWidth
              required
              inputProps={{ 'aria-label': 'Policy Holder' }}
            />
          </Box>
          <Box display="flex" flexDirection={{ xs: 'column', sm: 'row' }} gap={2} mt={2}>
            <TextField
              label="Date"
              name="date"
              type="date"
              value={claim.date}
              onChange={handleChange}
              error={!!errors.date}
              helperText={errors.date}
              fullWidth
              required
              InputLabelProps={{ shrink: true }}
              inputProps={{ 'aria-label': 'Date' }}
            />
            <TextField
              label="Status"
              name="status"
              value={claim.status}
              onChange={handleChange}
              error={!!errors.status}
              helperText={errors.status}
              fullWidth
              required
              inputProps={{ 'aria-label': 'Status' }}
            />
          </Box>
          <TextField
            label="Amount"
            name="amount"
            type="number"
            value={claim.amount}
            onChange={handleChange}
            error={!!errors.amount}
            helperText={errors.amount}
            fullWidth
            required
            inputProps={{ min: 0, 'aria-label': 'Amount' }}
            sx={{ mt: 2 }}
          />
          <Divider sx={{ my: 3 }} />
          <Box display="flex" justifyContent="flex-end" gap={2}>
            <Button variant="outlined" startIcon={<CancelIcon />} onClick={() => navigate('/claims')}>
              Cancel
            </Button>
            <Button variant="contained" color="primary" type="submit" disabled={submitting} startIcon={<SaveIcon />}>
              {submitting ? <CircularProgress size={24} color="inherit" /> : 'Save'}
            </Button>
          </Box>
        </form>
        <Snackbar open={success} autoHideDuration={1200} onClose={() => setSuccess(false)} anchorOrigin={{ vertical: 'top', horizontal: 'center' }}>
          <Alert severity="success" sx={{ width: '100%' }}>
            Claim saved successfully!
          </Alert>
        </Snackbar>
      </Paper>
    </Box>
  );
};

export default ClaimForm;
