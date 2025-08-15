import React, { useState, useEffect } from 'react';
import { supabase } from '../supabase';
import { capitalizeWords } from '../utils/text';
import type { Certificate } from '../types';

function AdminPanel() {
  const [formData, setFormData] = useState({
    name: '',
    rut: '',
    career: '',
    graduation_year: new Date().getFullYear()
  });
  const [links, setLinks] = useState<{ qr: string; view: string } | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [certificates, setCertificates] = useState<Certificate[]>([]);

  useEffect(() => {
    fetchCertificates();
  }, []);

  const fetchCertificates = async () => {
    try {
      const { data, error } = await supabase
        .from('certificates')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) {
        throw error;
      }

      if (data) {
        setCertificates(data);
      }
    } catch (error) {
      console.error('Error fetching certificates:', error);
      setError('Error al cargar los certificados');
    }
  };

  const validateRut = (rut: string) => {
    const rutRegex = /^\d{7,8}-[\d|k|K]$/;
    return rutRegex.test(rut);
  };

  const handleRutChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const rawValue = e.target.value.replace(/\./g, '');
    setFormData({ ...formData, rut: rawValue });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      if (!validateRut(formData.rut)) {
        throw new Error('El RUT debe tener el formato correcto (ejemplo: 17616251-1)');
      }
      
      const baseUrl = window.location.origin;

      const { data, error: insertError } = await supabase
        .from('certificates')
        .insert([{
          name: capitalizeWords(formData.name),
          rut: formData.rut,
          career: formData.career.toUpperCase(),
          graduation_year: formData.graduation_year,
          created_at: new Date().toISOString(),
          estado: 'En Proceso'
        }])
        .select()
        .single();

      if (insertError) {
        throw new Error(`Error al crear el certificado: ${insertError.message}`);
      }

      if (!data) {
        throw new Error('No se recibió confirmación de la creación del certificado');
      }

      const qrUrl = `https://certificadosvalidaduoc.cl/certificado/${data.id}`;
      const viewUrl = `https://certificadosvalidaduoc.cl/ValidacionQr?id=${data.id}`;

      // Update the certificate with the URLs
      const { error: updateError } = await supabase
        .from('certificates')
        .update({
          qr_url: qrUrl,
          view_url: viewUrl
        })
        .eq('id', data.id);

      if (updateError) {
        console.error('Error al actualizar URLs:', updateError);
      }

      setLinks({
        qr: qrUrl,
        view: viewUrl
      });
      
      setFormData({ 
        name: '', 
        rut: '', 
        career: '', 
        graduation_year: new Date().getFullYear() 
      });

      // Refresh certificates list
      fetchCertificates();
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Error desconocido al crear el certificado');
      console.error('Error creating certificate:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 className="text-2xl font-bold mb-6 text-center">Crear Certificado</h2>
          {error && (
            <div className="mb-4 p-4 text-red-700 bg-red-100 rounded-md">
              {error}
            </div>
          )}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700">Nombre</label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                required
                placeholder="Ingrese el nombre completo"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700">RUT</label>
              <input
                type="text"
                value={formData.rut}
                onChange={handleRutChange}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                required
                placeholder="17616251-1"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700">Carrera</label>
              <input
                type="text"
                value={formData.career}
                onChange={(e) => setFormData({ ...formData, career: e.target.value })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                required
                placeholder="Nombre de la carrera"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700">Año de Titulación</label>
              <input
                type="number"
                value={formData.graduation_year}
                onChange={(e) => setFormData({ ...formData, graduation_year: parseInt(e.target.value) })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                required
                min="1980"
                max={new Date().getFullYear()}
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className={`w-full bg-duoc-gold text-gray-900 py-2 px-4 rounded-md hover:bg-[#d6aa43] transition-colors ${
                loading ? 'opacity-50 cursor-not-allowed' : ''
              }`}
            >
              {loading ? 'Creando certificado...' : 'Crear Certificado'}
            </button>
          </form>
        </div>

        {links && (
          <div className="bg-white rounded-lg shadow-md p-6 mb-6">
            <h3 className="text-lg font-semibold mb-4">Enlaces del Certificado:</h3>
            <div className="space-y-4">
              <div>
                <p className="text-sm font-medium text-gray-700 mb-2">Certificado con Código QR:</p>
                <a
                  href={links.qr}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-indigo-600 hover:text-indigo-800 break-all"
                >
                  {links.qr}
                </a>
              </div>
              <div>
                <p className="text-sm font-medium text-gray-700 mb-2">Vista de Certificado:</p>
                <a
                  href={links.view}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-indigo-600 hover:text-indigo-800 break-all"
                >
                  {links.view}
                </a>
              </div>
            </div>
          </div>
        )}

        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-2xl font-bold mb-6">Certificados Existentes</h2>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">RUT</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Carrera</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {certificates.map((cert) => (
                  <tr key={cert.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{cert.id}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{cert.name}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{cert.rut}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{cert.career}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{cert.estado}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <a
                        href={`/certificado/${cert.id}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-indigo-600 hover:text-indigo-900 mr-4"
                      >
                        Ver QR
                      </a>
                      <a
                        href={`/ValidacionQr?id=${cert.id}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-indigo-600 hover:text-indigo-900"
                      >
                        Validar
                      </a>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

export default AdminPanel;