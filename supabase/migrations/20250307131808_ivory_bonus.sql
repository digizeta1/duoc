/*
  # Agregar URLs a certificados

  1. Cambios
    - Agregar columnas para almacenar URLs de certificados:
      - `qr_url`: URL del certificado con código QR
      - `view_url`: URL de la vista de validación
    
  2. Seguridad
    - Mantener las políticas de seguridad existentes
*/

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'certificates' AND column_name = 'qr_url'
  ) THEN
    ALTER TABLE certificates ADD COLUMN qr_url text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'certificates' AND column_name = 'view_url'
  ) THEN
    ALTER TABLE certificates ADD COLUMN view_url text;
  END IF;
END $$;