import { createClient } from '@supabase/supabase-js';
import type { Database } from './types/supabase';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Las variables de entorno de Supabase no están configuradas correctamente');
}

export const supabase = createClient<Database>(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  },
  global: {
    fetch: (...args) => {
      return fetch(...args).catch(err => {
        console.error('Error en la conexión con Supabase:', err);
        throw new Error('Error de conexión con el servidor. Por favor, verifique su conexión a internet e intente nuevamente.');
      });
    }
  }
});

// Verificar la conexión
supabase.from('certificates').select('count').single()
  .then(() => console.log('✅ Conexión a Supabase establecida'))
  .catch(error => {
    console.error('❌ Error al conectar con Supabase:', error);
    console.error('URL de Supabase:', supabaseUrl);
  });