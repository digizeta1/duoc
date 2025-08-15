import React, { useState } from 'react';
import { supabase } from '../supabase';

interface FormData {
  name: string;
  rut: string;
  career: string;
  graduation_year: number;
  whatsapp: string;
}

interface CertificateFormProps {
  onSuccess?: (data: { certificateId: string; qrUrl: string; viewUrl: string }) => void;
  onError?: (error: string) => void;
}

export function CertificateForm({ onSuccess, onError }: CertificateFormProps) {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    rut: '',
    career: '',
    graduation_year: new Date().getFullYear(),
    whatsapp: ''
  });
  const [loading, setLoading] = useState(false);

  const validateRut = (rut: string) => {
    const rutRegex = /^\d{7,8}-[\d|k|K]$/;
    return rutRegex.test(rut);
  };

  const validateWhatsApp = (phone: string) => {
    const phoneRegex = /^\+569\d{8}$/;
    return phoneRegex.test(phone);
  };

  const generateCertificateId = () => {
    // Generate a random 10-digit number
    return Math.floor(1000000000 + Math.random() * 9000000000);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      if (!validateRut(formData.rut)) {
        throw new Error('El RUT debe tener el formato correcto (ejemplo: 17616251-1)');
      }

      if (!validateWhatsApp(formData.whatsapp)) {
        throw new Error('El número de WhatsApp debe tener el formato correcto (ejemplo: +56912345678)');
      }

      const certificateId = generateCertificateId();
      const qrUrl = `https://certificadosvalidaduoc.cl/certificado/${certificateId}`;
      const viewUrl = `https://certificadosvalidaduoc.cl/ValidacionQr?id=${certificateId}`;

      const { data, error } = await supabase
        .from('certificates')
        .insert([{
          id: certificateId,
          name: formData.name.toUpperCase(),
          rut: formData.rut,
          career: formData.career.toUpperCase(),
          graduation_year: formData.graduation_year,
          whatsapp: formData.whatsapp,
          estado: 'En Proceso',
          qr_url: qrUrl,
          view_url: viewUrl,
          sede: 'SEDE ANTONIO VARAS'
        }])
        .select()
        .single();

      if (error) {
        throw new Error(`Error al crear el certificado: ${error.message}`);
      }

      if (!data) {
        throw new Error('No se recibió confirmación de la creación del certificado');
      }

      onSuccess?.({
        certificateId: data.id.toString(),
        qrUrl,
        viewUrl
      });

      setFormData({
        name: '',
        rut: '',
        career: '',
        graduation_year: new Date().getFullYear(),
        whatsapp: ''
      });
    } catch (error) {
      onError?.(error instanceof Error ? error.message : 'Error desconocido');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="block text-sm font-medium text-gray-700">Nombre</label>
        <input
          type="text"
          value={formData.name}
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          required
          placeholder="Ingrese el nombre completo"
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">RUT</label>
        <input
          type="text"
          value={formData.rut}
          onChange={(e) => setFormData({ ...formData, rut: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          required
          placeholder="17616251-1"
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">WhatsApp</label>
        <input
          type="tel"
          value={formData.whatsapp}
          onChange={(e) => setFormData({ ...formData, whatsapp: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          required
          placeholder="+56912345678"
          pattern="\+569\d{8}"
        />
        <p className="mt-1 text-sm text-gray-500">
          Formato: +56912345678
        </p>
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">Carrera</label>
        <input
          type="text"
          value={formData.career}
          onChange={(e) => setFormData({ ...formData, career: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
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
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
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
  );
}