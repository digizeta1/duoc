import React, { useState } from 'react';
import { supabase } from '../supabase';
import type { Certificate } from '../types';

// Add error boundary to catch any issues
class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean }
> {
  constructor(props: { children: React.ReactNode }) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error in ValidacionCertificados:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen bg-white flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-2xl font-bold text-red-600 mb-4">Error</h1>
            <p className="text-gray-600">Algo salió mal. Por favor, recarga la página.</p>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

function ValidacionCertificados() {
  const [rut, setRut] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [searchResults, setSearchResults] = useState<Certificate[]>([]);
  const [hasSearched, setHasSearched] = useState(false);
  const [showProcessingModal, setShowProcessingModal] = useState(false);
  const [showNotFoundModal, setShowNotFoundModal] = useState(false);

  const formatRut = (value: string) => {
    // Remove dots and spaces
    let cleaned = value.replace(/[.\s]/g, '');
    
    // Convert 'k' to 'K' for consistency
    cleaned = cleaned.replace(/k/g, 'K');
    
    // If there's already a hyphen, allow editing but limit to one character after it
    if (cleaned.includes('-')) {
      const parts = cleaned.split('-');
      if (parts.length === 2 && parts[1].length > 1) {
        // Keep only the first character after the hyphen
        cleaned = parts[0] + '-' + parts[1].charAt(0);
      }
      // If it's a valid format, return as is
      if (/^\d{7,9}-[\dK]$/.test(cleaned)) {
        return cleaned;
      }
    }
    
    // Only auto-format when we have exactly 9 digits (complete RUT)
    if (/^\d{9}$/.test(cleaned)) {
      return cleaned.slice(0, -1) + '-' + cleaned.slice(-1);
    }
    
    // For any other case (including 8 digits), return as typed to allow continuation
    return cleaned;
  };

  const handleRutChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const formattedRut = formatRut(e.target.value);
    setRut(formattedRut);
    setError(null);
  };

  const validateRut = (rut: string) => {
    // Check format: 7-9 numbers followed by hyphen and then number or 'K'
    // Now supports 7-8 digit RUTs
    const rutRegex = /^\d{7,8}-[\dK]$/;
    return rutRegex.test(rut);
  };

  const handleValidate = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setHasSearched(false);
    setSearchResults([]);

    try {
      if (!rut.trim()) {
        setError('Por favor ingrese un RUN');
        return;
      }

      if (!validateRut(rut)) {
        setError('El RUN debe tener el formato correcto (ejemplo: 9130489-9, 17616251-1 o 158886405)');
        return;
      }

      // Show processing modal
      setShowProcessingModal(true);
      setLoading(true);

      // Simulate a small delay to show the processing modal
      await new Promise(resolve => setTimeout(resolve, 800));

      const { data, error: searchError } = await supabase
        .from('certificates')
        .select('*')
        .eq('rut', rut);

      if (searchError) {
        throw new Error('Error al buscar el certificado');
      }

      // Hide processing modal
      setShowProcessingModal(false);
      setLoading(false);

      if (!data || data.length === 0) {
        // Show not found modal instead of setting error
        setShowNotFoundModal(true);
      } else {
        setSearchResults(data);
        setHasSearched(true);
      }
    } catch (error) {
      setShowProcessingModal(false);
      setLoading(false);
      setError(error instanceof Error ? error.message : 'Error al validar el certificado');
    }
  };

  const closeNotFoundModal = () => {
    setShowNotFoundModal(false);
  };

  const closeProcessingModal = () => {
    setShowProcessingModal(false);
    setLoading(false);
  };

  return (
    <ErrorBoundary>
    <div className="min-h-screen bg-white">
      {/* Header */}
      <div className="w-full bg-black">
        <div className="max-w-7xl mx-auto px-4 sm:px-8 py-3">
          <img
            src="/images/duoc.jpg"
            alt="DuocUC"
            className="h-8 w-auto object-contain"
          />
        </div>
      </div>

      {/* Main Content */}
      <div className="w-full py-4 sm:py-8">
        <div 
          className="mx-4 sm:mx-10 lg:mx-40 p-4 sm:p-8 lg:p-16 border-2 sm:border-3 border-black"
          style={{
            minHeight: window.innerWidth < 768 ? '300px' : '400px'
          }}
        >
          <h1 className="text-xl sm:text-2xl font-normal text-center mb-8 sm:mb-16">
            Validación de RUN
          </h1>

          {/* Form Container - Responsive layout */}
          <div className="text-center">
            <form onSubmit={handleValidate}>
              {/* RUT Input - Mobile responsive */}
              <div className="flex flex-col sm:inline-flex sm:flex-row items-center gap-2 sm:gap-4 mb-6">
                <label htmlFor="rut" className="text-base font-medium whitespace-nowrap mb-2 sm:mb-0">
                  RUT:
                </label>
                <input
                  type="text"
                  id="rut"
                  value={rut}
                  onChange={handleRutChange}
                  placeholder="19930811-4"
                  className="border border-gray-400 rounded px-3 py-2 text-base w-full sm:w-auto"
                  style={{
                    width: window.innerWidth < 640 ? '100%' : '200px',
                    maxWidth: '300px',
                    height: '35px'
                  }}
                  maxLength={11}
                />
              </div>

              {/* Validation Button - Centered below input */}
              <div className="mb-4">
                <button
                  type="submit"
                  disabled={loading}
                  className="bg-[#5BA4CF] text-white px-6 py-2 rounded flex items-center gap-2 hover:bg-[#4A93BE] transition-colors disabled:opacity-50 disabled:cursor-not-allowed mx-auto"
                >
                  <svg 
                    viewBox="0 0 24 24" 
                    className="w-4 h-4" 
                    fill="none" 
                    stroke="currentColor" 
                    strokeWidth="2"
                  >
                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z" />
                    <circle cx="12" cy="12" r="3" />
                  </svg>
                  VALIDAR
                </button>
              </div>

              {error && (
                <div className="text-red-600 text-sm">
                  {error}
                </div>
              )}
            </form>
          </div>

          {/* Results Table - Mobile responsive */}
          {hasSearched && searchResults.length > 0 && (
            <div className="mt-8 sm:mt-16">
              {/* Table Controls - Mobile responsive */}
              <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-4 gap-4">
                <div className="flex items-center gap-2 text-sm">
                  <span>Mostrar</span>
                  <select className="border border-gray-300 rounded px-2 py-1 text-sm">
                    <option value="10">10</option>
                    <option value="25">25</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                  </select>
                  <span>entradas</span>
                </div>
                <div className="flex items-center gap-2 text-sm">
                  <span>Buscar:</span>
                  <input 
                    type="text" 
                    className="border border-gray-300 rounded px-2 py-1 text-sm w-32 sm:w-48"
                    placeholder=""
                  />
                </div>
              </div>

              {/* Mobile Table - Card layout for mobile, table for desktop */}
              <div className="block sm:hidden">
                {/* Mobile Card Layout */}
                {searchResults.map((certificate, index) => (
                  <div key={certificate.id} className="border border-gray-300 rounded mb-4 p-4 bg-white shadow-sm">
                    <div className="space-y-3">
                      <div>
                        <span className="font-medium text-gray-700">Nombre y Apellido:</span>
                        <div className="text-sm mt-1">{certificate.name}</div>
                      </div>
                      <div>
                        <span className="font-medium text-gray-700">RUN:</span>
                        <div className="text-sm mt-1">{certificate.rut}</div>
                      </div>
                      <div>
                        <span className="font-medium text-gray-700">Carrera:</span>
                        <div className="text-sm mt-1">{certificate.career}</div>
                      </div>
                      <div>
                        <span className="font-medium text-gray-700">Estado:</span>
                        <div className="text-sm mt-1 font-medium">TITULADO</div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              {/* Desktop Table */}
              <div className="hidden sm:block border border-gray-300 rounded overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-gray-100">
                    <tr>
                      <th className="px-4 py-3 text-left font-medium text-gray-700 border-b border-gray-300">
                        Nombre y Apellido
                      </th>
                      <th className="px-4 py-3 text-left font-medium text-gray-700 border-b border-gray-300">
                        RUN
                      </th>
                      <th className="px-4 py-3 text-left font-medium text-gray-700 border-b border-gray-300">
                        Carrera
                      </th>
                      <th className="px-4 py-3 text-left font-medium text-gray-700 border-b border-gray-300">
                        Estado
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {searchResults.map((certificate, index) => (
                      <tr key={certificate.id} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                        <td className="px-4 py-3 border-b border-gray-200">
                          {certificate.name}
                        </td>
                        <td className="px-4 py-3 border-b border-gray-200">
                          {certificate.rut}
                        </td>
                        <td className="px-4 py-3 border-b border-gray-200">
                          {certificate.career}
                        </td>
                        <td className="px-4 py-3 border-b border-gray-200">
                          <span className="font-medium">TITULADO</span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Table Footer - Mobile responsive */}
              <div className="mt-4 flex flex-col sm:flex-row justify-between items-center text-sm text-gray-600 gap-4">
                <div className="text-center sm:text-left">
                  Mostrando 1 a {searchResults.length} de {searchResults.length} registros
                </div>
                <div className="flex items-center gap-2">
                  <button className="px-3 py-1 border border-gray-300 rounded text-gray-500 cursor-not-allowed">
                    Anterior
                  </button>
                  <span className="px-3 py-1 bg-blue-500 text-white rounded">1</span>
                  <button className="px-3 py-1 border border-gray-300 rounded text-gray-500 cursor-not-allowed">
                    Siguiente
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Processing Modal - Mobile responsive */}
      {showProcessingModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 sm:p-8 max-w-xs w-full mx-4 text-center shadow-2xl">
            {/* Processing Text with Sindelar Medium font */}
            <p 
              className="text-gray-600 mb-6"
              style={{ 
                fontSize: '1.125rem',
                fontWeight: '500',
                color: '#6B7280',
                fontFamily: "'Sindelar Medium', system-ui, -apple-system, sans-serif"
              }}
            >
              Procesando...
            </p>
            
            {/* Loading Spinner */}
            <div className="flex justify-center">
              <div className="w-10 h-10 sm:w-12 sm:h-12 border-4 border-blue-200 border-t-blue-500 rounded-full animate-spin"></div>
            </div>
          </div>
        </div>
      )}

      {/* Not Found Modal - Mobile responsive */}
      {showNotFoundModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 sm:p-8 max-w-lg w-full mx-4 text-center shadow-2xl">
            {/* SweetAlert2 Error Icon */}
            <div className="flex justify-center mb-6">
              <div className="swal2-icon swal2-error" style={{ display: 'flex' }}>
                <span className="swal2-x-mark">
                  <span className="swal2-x-mark-line-left"></span>
                  <span className="swal2-x-mark-line-right"></span>
                </span>
              </div>
            </div>
            
            {/* Message with Sindelar Medium font - Mobile responsive */}
            <h2 
              className="mb-6 sm:mb-8 leading-relaxed text-center"
              style={{ 
                fontSize: window.innerWidth < 640 ? '1.25rem' : '1.5rem',
                fontWeight: '500',
                lineHeight: '1.5',
                color: '#000000',
                fontFamily: "'Sindelar Medium', system-ui, -apple-system, sans-serif"
              }}
            >
              "Rut de consulta no se encuentra en los registros de Duoc UC como Titulado o Egresado."
            </h2>
            
            {/* OK Button */}
            <button
              onClick={closeNotFoundModal}
              className="bg-[#5BA4CF] text-white px-6 sm:px-8 py-2 rounded-lg hover:bg-[#4A93BE] transition-colors font-medium"
            >
              OK
            </button>
          </div>
        </div>
      )}

      {/* SweetAlert2 Error Icon Styles */}
      <style jsx>{`
        .swal2-icon {
          position: relative;
          box-sizing: content-box;
          justify-content: center;
          width: 4em;
          height: 4em;
          margin: 0 auto 1.25em;
          border: 0.25em solid transparent;
          border-radius: 50%;
          font-family: inherit;
          line-height: 4em;
          cursor: default;
          user-select: none;
        }

        @media (min-width: 640px) {
          .swal2-icon {
            width: 5em;
            height: 5em;
            line-height: 5em;
          }
        }

        .swal2-icon.swal2-error {
          border-color: #f27474;
          color: #f27474;
        }

        .swal2-x-mark {
          position: relative;
          display: block;
          margin-left: auto;
          margin-right: auto;
        }

        .swal2-icon.swal2-error .swal2-x-mark {
          position: relative;
          flex-grow: 1;
        }

        .swal2-icon.swal2-error [class^=swal2-x-mark-line] {
          display: block;
          position: absolute;
          top: 1.875em;
          width: 2.375em;
          height: 0.3125em;
          border-radius: 0.125em;
          background-color: #f27474;
        }

        @media (min-width: 640px) {
          .swal2-icon.swal2-error [class^=swal2-x-mark-line] {
            top: 2.3125em;
            width: 2.9375em;
          }
        }

        .swal2-icon.swal2-error [class^=swal2-x-mark-line][class$=left] {
          left: 0.8125em;
          transform: rotate(45deg);
        }

        @media (min-width: 640px) {
          .swal2-icon.swal2-error [class^=swal2-x-mark-line][class$=left] {
            left: 1.0625em;
          }
        }

        .swal2-icon.swal2-error [class^=swal2-x-mark-line][class$=right] {
          right: 0.8125em;
          transform: rotate(-45deg);
        }

        @media (min-width: 640px) {
          .swal2-icon.swal2-error [class^=swal2-x-mark-line][class$=right] {
            right: 1em;
          }
        }

        .swal2-icon.swal2-error.swal2-animate-error-icon {
          animation: swal2-animate-error-icon 0.5s;
        }

        @keyframes swal2-animate-error-icon {
          0% {
            transform: rotateX(100deg);
            opacity: 0;
          }
          100% {
            transform: rotateX(0deg);
            opacity: 1;
          }
        }
      `}</style>
    </div>
    </ErrorBoundary>
  );
}

export default ValidacionCertificados;