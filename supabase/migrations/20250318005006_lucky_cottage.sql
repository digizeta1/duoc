/*
  # Add WhatsApp column to certificates table

  1. Changes
    - Add `whatsapp` column to certificates table
    - Column is nullable to maintain compatibility with existing records
    - Stores phone numbers in international format (e.g., +56912345678)

  2. Notes
    - Uses IF NOT EXISTS check to prevent errors if column already exists
    - Phone numbers should include country code
*/

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'certificates' AND column_name = 'whatsapp'
  ) THEN
    ALTER TABLE certificates ADD COLUMN whatsapp text;
  END IF;
END $$;