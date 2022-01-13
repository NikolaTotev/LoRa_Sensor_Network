import React from 'react';
import ButtonAppBar from './components/Header';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import { CssBaseline } from '@mui/material';
import { ServerSocketProvider } from './contexts/ServerSocket';
import Home from './pages/Home';

export default function App() {
  return (
    <BrowserRouter>
      <ServerSocketProvider>
        <CssBaseline />
        <ButtonAppBar />
        <Routes>
          <Route path="/home" element={<Home />} />
          <Route path="*" element={<Navigate replace to="/home" />} />
        </Routes>
      </ServerSocketProvider>
    </BrowserRouter>
  );
}
