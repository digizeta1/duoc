/*
  # Make certificate fields optional with defaults

  1. Changes
    - Make rut column optional with empty string default
    - Make career column optional with 'No declarada' default
    - Make graduation_year column optional with 0 default

  2. Notes
    - Uses ALTER TABLE to modify existing columns
    - Sets appropriate default values for each column
    - Maintains data integrity by providing sensible defaults
*/

ALTER TABLE certificates
  ALTER COLUMN rut DROP NOT NULL,
  ALTER COLUMN rut SET DEFAULT '',
  ALTER COLUMN career DROP NOT NULL,
  ALTER COLUMN career SET DEFAULT 'No declarada',
  ALTER COLUMN graduation_year DROP NOT NULL,
  ALTER COLUMN graduation_year SET DEFAULT 0;