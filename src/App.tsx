import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import CertificateQR from './pages/CertificateQR';
import CertificateView from './pages/CertificateView';
import ValidacionCertificados from './pages/ValidacionCertificados';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Navigate to="/ValidacionCertificados" replace />} />
        <Route path="/certificado/:id" element={<CertificateQR />} />
        <Route path="/ValidacionQr" element={<CertificateView />} />
        <Route path="/ValidacionCertificados" element={<ValidacionCertificados />} />
      </Routes>
    </Router>
  );
}

export default App;