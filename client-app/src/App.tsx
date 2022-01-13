import React from 'react';
import Header from './components/Header';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import { CssBaseline } from '@mui/material';
import { ServerSocketProvider } from './contexts/ServerSocket';
import Home from './pages/Home';
import Stations from './pages/Stations';
import History from './pages/History';

export default function App() {
  return (
    <BrowserRouter>
      <ServerSocketProvider>
        <CssBaseline />
        <Header />
        <Routes>
          <Route path="/home" element={<Home />} />
          <Route path="/history" element={<History />} />
          <Route path="/stations" element={<Stations />} />
          <Route path="*" element={<Navigate replace to="/home" />} />
        </Routes>
      </ServerSocketProvider>
    </BrowserRouter>
  );
}
