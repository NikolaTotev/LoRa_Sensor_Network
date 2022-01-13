import React from 'react';
import ButtonAppBar from './components/Header';
import { BrowserRouter, Route, Routes } from 'react-router-dom';
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
          <Route path="/" element={<Home />} />
        </Routes>
      </ServerSocketProvider>
    </BrowserRouter>
  );
}
