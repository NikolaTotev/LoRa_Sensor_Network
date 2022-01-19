import { Box, CircularProgress } from '@mui/material';
import React, { ReactNode } from 'react';

interface LoadingProps {
  loading: boolean;
  error: Error | null;
  children: () => ReactNode;
}

export default function Loading( { loading, error, children }: LoadingProps) {
  if (loading) {
    return (
      <Box m={4} textAlign="center" >
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box m={4} textAlign="center">{error.message}</Box>
    );
  }

  return <>{children()}</>;
}