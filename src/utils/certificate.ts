import { supabase } from '../supabase';

export const createCertificate = async (formData: {
  name: string;
  rut: string;
  career: string;
  graduation_year: number;
  whatsapp: string;
}) => {
  try {
    if (!supabase) {
      throw new Error('La conexión con Supabase no está disponible');
    }

    const baseUrl = 'https://certificadosvalidaduoc.cl';

    const { data, error } = await supabase
      .from('certificates')
      .insert([{
        name: formData.name.toUpperCase(),
        rut: formData.rut,
        career: formData.career.toUpperCase(),
        graduation_year: formData.graduation_year,
        created_at: new Date().toISOString(),
        estado: 'En Proceso',
        whatsapp: formData.whatsapp
      }])
      .select()
      .single();

    if (error) {
      console.error('Error de Supabase:', error);
      throw new Error(`Error al crear el certificado: ${error.message}`);
    }

    if (!data) {
      throw new Error('No se recibió confirmación de la creación del certificado');
    }

    const qrUrl = `${baseUrl}/certificado/${data.id}`;
    const viewUrl = `${baseUrl}/ValidacionQr?id=${data.id}`;

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

    return {
      success: true,
      certificateId: data.id,
      qrUrl,
      viewUrl
    };
  } catch (error) {
    console.error('Error en createCertificate:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Error desconocido al crear el certificado'
    };
  }
};