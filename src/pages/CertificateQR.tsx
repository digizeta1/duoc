import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import QRCode from 'qrcode';
import { supabase } from '../supabase';
import type { Certificate } from '../types';
import { jsPDF } from 'jspdf';
import html2canvas from 'html2canvas';
// Use existing images from public directory

function CertificateQR() {
  const { id } = useParams();
  const [certificate, setCertificate] = useState<Certificate | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [downloading, setDownloading] = useState(false);
  const [qrDataUrl, setQrDataUrl] = useState<string>('');

  const formatDate = (date: string | null) => {
    if (!date) return '';
    const d = new Date(date);
    // Add one day to the date
    d.setDate(d.getDate() + 1);
    return `${d.getDate().toString().padStart(2, '0')}-${(d.getMonth() + 1).toString().padStart(2, '0')}-${d.getFullYear()}`;
  };

  const getCurrentDate = () => {
    const today = new Date();
    return `${today.getDate().toString().padStart(2, '0')}-${(today.getMonth() + 1).toString().padStart(2, '0')}-${today.getFullYear()}`;
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
          throw new Error(`Error al buscar el certificado: ${supabaseError.message}`);
        }

        if (!data) {
          setError('Certificado no encontrado');
          setLoading(false);
          return;
        }

        setCertificate(data);

        // Generate QR code as data URL using the production URL
        const validationUrl = `https://certificadosvalidaduoc.cl/ValidacionQr?id=${data.id}`;
        const qrUrl = await QRCode.toDataURL(validationUrl, {
          width: 120,
          margin: 0,
          color: {
            dark: '#000000',
            light: '#ffffff'
          }
        });
        setQrDataUrl(qrUrl);

        // Update certificate URLs if they don't match production URLs
        const expectedQrUrl = `https://certificadosvalidaduoc.cl/certificado/${data.id}`;
        const expectedViewUrl = `https://certificadosvalidaduoc.cl/ValidacionQr?id=${data.id}`;
        
        if (data.qr_url !== expectedQrUrl || data.view_url !== expectedViewUrl) {
          await supabase
            .from('certificates')
            .update({
              qr_url: expectedQrUrl,
              view_url: expectedViewUrl
            })
            .eq('id', data.id);
        }
      } catch (error) {
        console.error('Error al buscar el certificado:', error);
        setError(error instanceof Error ? error.message : 'Error al buscar el certificado');
      } finally {
        setLoading(false);
      }
    };

    fetchCertificate();
  }, [id]);

  const loadImageAsDataURL = (src: string): Promise<string> => {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.crossOrigin = 'anonymous';
      img.onload = () => {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        canvas.width = img.width;
        canvas.height = img.height;
        ctx?.drawImage(img, 0, 0);
        resolve(canvas.toDataURL('image/png'));
      };
      img.onerror = () => reject(new Error(`Failed to load image: ${src}`));
      img.src = src;
    });
  };

  const updateCertificateStatus = async () => {
    if (!certificate) return;

    try {
      await supabase
        .from('certificates')
        .update({ estado: 'Pagado' })
        .eq('id', certificate.id);
    } catch (error) {
      console.error('Error al actualizar el estado del certificado:', error);
    }
  };

  const handleDownloadPDF = async () => {
    if (!certificate) return;
    setDownloading(true);

    try {
      // Update certificate status to 'Pagado'
      await updateCertificateStatus();

      const certificateElement = document.getElementById('certificate-content');
      if (!certificateElement) {
        throw new Error('No se pudo encontrar el contenido del certificado');
      }

      // Create a clone of the certificate element for PDF generation
      const clone = certificateElement.cloneNode(true) as HTMLElement;
      document.body.appendChild(clone);
      clone.style.position = 'absolute';
      clone.style.left = '-9999px';
      clone.style.top = '0';
      clone.style.width = '794px';  // A4 width in pixels
      clone.style.height = '1150px';
      clone.style.backgroundColor = 'white';
      clone.style.transform = 'none';
      clone.style.margin = '0';
      clone.style.padding = '40px';

      // Convert all images to data URLs to ensure they appear in PDF
      const images = clone.getElementsByTagName('img');
      for (let i = 0; i < images.length; i++) {
        const img = images[i];
        try {
          if (img.src.startsWith('data:')) {
            // Already a data URL, skip
            continue;
          }
          
          // Convert to data URL
          const dataUrl = await loadImageAsDataURL(img.src);
          img.src = dataUrl;
        } catch (error) {
          console.warn('Failed to convert image to data URL:', img.src, error);
        }
      }

      // Wait for fonts to load
      await document.fonts.ready;

      // Wait for all images to load
      await Promise.all([
        ...Array.from(clone.getElementsByTagName('img')).map(
          (img) =>
            new Promise((resolve) => {
              if (img.complete) {
                resolve(null);
              } else {
                img.onload = resolve;
                img.onerror = resolve;
              }
            })
        )
      ]);

      // Generate PDF with better text rendering settings
      const canvas = await html2canvas(clone, {
        scale: 2, // Reduced scale to prevent text rendering issues
        useCORS: true,
        allowTaint: true,
        backgroundColor: '#ffffff',
        width: 794,
        height: 1150,
        logging: false,
        letterRendering: false, // Disable to prevent spacing issues
        foreignObjectRendering: false,
        onclone: (clonedDoc) => {
          const clonedElement = clonedDoc.getElementById('certificate-content');
          if (clonedElement) {
            clonedElement.style.width = '794px';
            clonedElement.style.height = '1150px';
            clonedElement.style.fontSmooth = 'never';
            clonedElement.style.webkitFontSmoothing = 'subpixel-antialiased';
            clonedElement.style.textRendering = 'geometricPrecision';
            
            // Ensure proper text spacing
            const textElements = clonedElement.querySelectorAll('p, div, span');
            textElements.forEach(el => {
              const element = el as HTMLElement;
              element.style.wordSpacing = '0.3em';
              element.style.letterSpacing = '0.08em';
              element.style.whiteSpace = 'pre-wrap';
              element.style.fontKerning = 'auto';
              element.style.textRendering = 'geometricPrecision';
              element.style.fontFeatureSettings = '"kern" 1';
              
              // Force word separation
              const text = element.textContent;
              if (text) {
                element.innerHTML = text.replace(/\s+/g, ' ').split(' ').join('&nbsp;');
              }
            });
            clonedElement.style.whiteSpace = 'pre-wrap';
            clonedElement.style.fontKerning = 'normal';
            clonedElement.style.textRendering = 'optimizeLegibility';
          }
        }
      });

      // Remove clone after canvas generation
      document.body.removeChild(clone);

      const imgData = canvas.toDataURL('image/jpeg', 1.0);
      const pdf = new jsPDF({
        orientation: 'portrait',
        unit: 'px',
        format: [794, 1150],
        hotfixes: ['px_scaling'],
        compress: true
      });

      pdf.addImage(imgData, 'JPEG', 0, 0, 794, 1150, undefined, 'FAST');
      pdf.save(`certificado-${certificate.id}.pdf`);
    } catch (error) {
      console.error('Error al generar PDF:', error);
      alert('Error al generar el PDF. Por favor, intente nuevamente.');
    } finally {
      setDownloading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <div className="text-xl text-gray-600">Cargando...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <div className="bg-white p-8 rounded-lg shadow-md">
          <h2 className="text-2xl font-bold text-red-600 mb-4">Error</h2>
          <p className="text-gray-700">{error}</p>
        </div>
      </div>
    );
  }

  if (!certificate) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <div className="bg-white p-8 rounded-lg shadow-md">
          <h2 className="text-2xl font-bold text-red-600 mb-4">Error</h2>
          <p className="text-gray-700">No se encontró el certificado solicitado</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100 py-8">
      {/* Fixed container that maintains desktop layout on all devices */}
      <div className="w-full flex justify-center overflow-x-auto">
        <div
          id="certificate-content"
          className="bg-white shadow-lg relative flex-shrink-0"
          style={{
            width: '794px',
            height: '1050px',
            padding: '40px',
            fontFamily: "'Times New Roman', serif",
            backgroundColor: '#ffffff',
            minWidth: '794px' // Prevent shrinking on mobile
          }}
        >
          {/* Border */}
          <div className="absolute inset-4 border-[1px] border-[#ff2425] pointer-events-none"></div>

          {/* Header with logo and text side by side */}
          <div className="flex flex-row justify-between items-start mb-6">
            <div className="text-[10px] uppercase mt-2" style={{ lineHeight: '1.2', letterSpacing: '0.5px', wordSpacing: '2px' }}>
              <p style={{ marginBottom: '4px' }}>INSTITUTO PROFESIONAL DUOCUC</p>
              <p style={{ marginBottom: '4px' }}>DEC. EX. Nº 3/1983 - Nº 180/1994 - Nº 7169/1995 - Nº 204/1999</p>
              <p style={{ marginBottom: '4px' }}>MINISTERIO DE EDUCACIÓN</p>
              <p style={{ marginBottom: '4px' }}>REGISTRO Nº 17</p>
              <p style={{ marginBottom: '4px' }}>{certificate.sede || 'SEDE ANTONIO VARAS'}</p>
            </div>
            <img 
              src="/images/duoc-logo.png"
              alt="DuocUC Logo"
              className="w-32 h-auto -mt-4"
              crossOrigin="anonymous"
            />
          </div>

          {/* Title */}
          <div className="text-center mb-12">
            <h1 
              className="text-[14px] uppercase tracking-wide underline font-bold mt-2"
              style={{
                fontFamily: "'Mathilde', serif"
              }}
            >
              CERTIFICADO DE TÍTULO
            </h1>
          </div>

          {/* Main Content */}
          <div className="text-justify leading-relaxed mb-10 text-[14px]">
            <p style={{ 
              fontFamily: "'Foundation Roman', serif", 
              wordSpacing: '0.3em', 
              letterSpacing: '0.05em',
              whiteSpace: 'pre-wrap',
              textRendering: 'geometricPrecision'
            }}>
              Certifico que conforme a la ley Orgánica Constitucional de Enseñanza, los Reglamentos del INSTITUTO PROFESIONAL
              DUOCUC y según consta en Registro de Título Nº {certificate.id} con fecha {formatDate(certificate.fecha_certificado)} se otorgó a don(a) {certificate.name}, 
              RUT Nº {certificate.rut} el título nivel profesional de:
            </p>
          </div>

          {/* Career */}
          <div 
            className="text-center text-[14px] mb-12"
            style={{ 
              fontFamily: 'EucrosiaUPC, serif',
              fontWeight: 'bold'
            }}
          >
            {certificate.career}
          </div>

          {/* Grade with proper spacing */}
          <div className="text-left text-[14px] mb-12" style={{ 
            wordSpacing: '0.4em', 
            letterSpacing: '0.08em',
            whiteSpace: 'pre-wrap',
            textRendering: 'geometricPrecision',
            fontKerning: 'auto'
          }}>
            <span>La Nota de Titulación obtenida fue un 6,3 (seis coma tres)</span>
          </div>

          {/* Date */}
          <div className="mb-12 mt-32 text-[14px] ml-[0px]">
            Santiago (Chile), {getCurrentDate()}
          </div>

          {/* Footer with QR and Image */}
          <div className="flex justify-between items-start mt-auto pt-16">
            <div id="qr-container" style={{ backgroundColor: '#ffffff' }}>
              {qrDataUrl && (
                <img
                  src={qrDataUrl}
                  alt="QR Code"
                  width={120}
                  height={120}
                  style={{ display: 'block' }}
                  crossOrigin="anonymous"
                />
              )}
            </div>
            <div className="-mt-32">
              <img
                src="/images/firma.png"
                alt="Firma"
                className="w-64 h-auto -mt-12"
                crossOrigin="anonymous"
              />
            </div>
          </div>

          {/* Legal text section - completely separate */}
          <div className="mt-8">
            <p className="text-[14px] mt-12 max-w-[750px]" style={{ 
              lineHeight: '1.5',
              wordSpacing: '0.3em', 
              letterSpacing: '0.05em',
              whiteSpace: 'pre-wrap',
              textRendering: 'geometricPrecision'
            }}>
              Para verificar la validez del presente certificado debe escanear el Código QR.
            </p>
            <p className="text-[14px] mt-6 max-w-[680px]" style={{ 
              lineHeight: '1.5',
              wordSpacing: '0.3em', 
              letterSpacing: '0.05em',
              whiteSpace: 'pre-wrap',
              textRendering: 'geometricPrecision'
            }}>
              Las Certificaciones emitidas a través de esta página, son otorgadas bajo Firma Electrónica Avanzada, en conformidad a lo dispuesto en la Ley N° 19.799 y su Reglamento.
            </p>
            <div className="mt-12"></div>
          </div>
        </div>
      </div>

      {/* Download button - responsive positioning */}
      <div className="w-full flex justify-center mt-8 px-4">
        <button
          onClick={handleDownloadPDF}
          disabled={downloading}
          className={`bg-duoc-gold text-gray-900 px-6 py-2 rounded-full hover:bg-[#d6aa43] transition-colors font-medium ${
            downloading ? 'opacity-50 cursor-not-allowed' : ''
          }`}
        >
          {downloading ? 'Generando PDF...' : 'Descargar PDF'}
        </button>
      </div>
    </div>
  );
}

export default CertificateQR;