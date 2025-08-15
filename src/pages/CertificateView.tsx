import React, { useEffect, useState } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { supabase } from '../supabase';
import type { Certificate } from '../types';
import { jsPDF } from 'jspdf';
import html2canvas from 'html2canvas';
import { DUOC_LOGO_URL, DUOC_LOGO_WHITE_URL } from '../constants';

function CertificateView() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [certificate, setCertificate] = useState<Certificate | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const id = searchParams.get('id');

  const formatDate = (date: string | null) => {
    if (!date) return '';
    const d = new Date(date);
    // Add one day to the date
    d.setDate(d.getDate() + 1);
    return `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()}`;
  };

  useEffect(() => {
    const fetchCertificate = async () => {
      if (!id) {
        setError('ID de certificado no proporcionado');
        setLoading(false);
        return;
      }

      try {
        const numericId = parseInt(id, 10);
        
        if (isNaN(numericId)) {
          setError('ID de certificado inválido');
          setLoading(false);
          return;
        }

        const { data, error: supabaseError } = await supabase
          .from('certificates')
          .select('*')
          .eq('id', numericId)
          .maybeSingle();

        if (supabaseError) {
          console.error('Error de Supabase:', supabaseError);
          setError('Error al buscar el certificado');
          setLoading(false);
          return;
        }

        if (!data) {
          setError('Certificado no encontrado');
          setLoading(false);
          return;
        }

        setCertificate(data);
        setLoading(false);
      } catch (error) {
        console.error('Error al buscar el certificado:', error);
        setError('Error al buscar el certificado');
        setLoading(false);
      }
    };

    fetchCertificate();
  }, [id]);

  const handleDownloadPDF = () => {
    navigate('/ValidacionCertificados');
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-white">
        <div className="w-full bg-black">
          <div className="max-w-7xl mx-auto px-4 sm:px-8 py-3">
            <img
              src="/images/duoc.jpg"
              alt="DuocUC"
              className="h-4 w-auto object-contain"
            />
          </div>
        </div>
        <div className="flex items-center justify-center h-[calc(100vh-56px)]">
          <div className="text-xl text-gray-600">Cargando...</div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-white">
        <div className="w-full bg-black">
          <div className="max-w-7xl mx-auto px-4 sm:px-8 py-3">
            <img
              src="/images/duoc.jpg"
              alt="DuocUC"
              className="h-4 w-auto object-contain"
            />
          </div>
        </div>
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="bg-red-50 border-l-4 border-red-400 p-4 rounded">
            <div className="flex">
              <div className="flex-shrink-0">
                <svg className="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-3">
                <h3 className="text-sm font-medium text-red-800">Error</h3>
                <div className="mt-2 text-sm text-red-700">
                  <p>{error}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (!certificate) {
    return (
      <div className="min-h-screen bg-white">
        <div className="w-full bg-black">
          <div className="max-w-7xl mx-auto px-4 sm:px-8 py-3">
            <img
              src="/images/duoc.jpg"
              alt="DuocUC"
              className="h-8 w-auto object-contain"
            />
          </div>
        </div>
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4 rounded">
            <div className="flex">
              <div className="flex-shrink-0">
                <svg className="h-5 w-5 text-yellow-400" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-3">
                <h3 className="text-sm font-medium text-yellow-800">Certificado no encontrado</h3>
                <div className="mt-2 text-sm text-yellow-700">
                  <p>No se encontró el certificado solicitado</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-white">
      <div className="w-full bg-black">
        <div className="max-w-7xl mx-auto px-4 sm:px-8 py-3">
          <img
            src="/images/duoc.jpg"
            alt="DuocUC"
            className="h-8 w-auto object-contain"
          />
        </div>
      </div>

      <div className="max-w-3xl mx-auto px-4 py-8" id="certificate-content">
        <div className="flex items-center gap-4 mb-8">
          <div className="w-2 h-12 bg-[#ddb961] rounded-full"></div>
          <h1 className="text-4xl text-gray-900" style={{ fontFamily: 'system-ui' }}>
            Certificado Vigente
          </h1>
        </div>

        <p className="text-lg font-semibold mb-2">
          Emitido el {formatDate(certificate.fecha_certificado)}
        </p>

        <p className="text-gray-600 mb-8 text-sm leading-relaxed">
          Las certificaciones emitidas a través de esta página, son otorgadas bajo Firma Electrónica Avanzada, 
          en conformidad a lo dispuesto en la ley Nº 19799 y su Reglamento. Si presenta algún incidente, contacte a la 
          mesa de servicios al <span className="font-bold">(+56) 44220108</span>, marcando la opción 5.
        </p>

        <h2 className="text-2xl font-bold text-gray-900 mb-6 uppercase">
          Certificado de Título
        </h2>

        <div className="text-lg space-y-2">
          <p>{certificate.name}</p>
          <p>{certificate.rut}</p>
          <p>ID Certificado: <span className="font-bold">{certificate.id}</span></p>
          <p>{certificate.career}</p>
        </div>

        <div className="flex flex-wrap gap-4 mt-8">
          <button 
            onClick={handleDownloadPDF}
            className="bg-[#ddb961] text-black px-6 py-3 rounded-full font-medium hover:bg-opacity-90 transition-colors"
          >
            Descargar PDF
          </button>
          <a 
            href="https://www.duoc.cl"
            target="_blank"
            rel="noopener noreferrer"
            className="border border-black text-black px-6 py-3 rounded-full font-medium hover:bg-black hover:text-white transition-colors"
          >
            Ir a Duoc.cl
          </a>
        </div>
      </div>
    </div>
  );
}

export default CertificateView;