/*
  # Create certificates table

  1. New Tables
    - `certificates`
      - `id` (text, primary key) - Unique certificate ID
      - `name` (text) - Student name in uppercase
      - `rut` (text) - Chilean ID number
      - `career` (text) - Career name in uppercase
      - `created_at` (timestamptz) - Certificate creation date

  2. Security
    - Enable RLS on `certificates` table
    - Add policies for:
      - Public read access to certificates
      - Authenticated users can create certificates
*/

CREATE TABLE IF NOT EXISTS certificates (
  id text PRIMARY KEY,
  name text NOT NULL,
  rut text NOT NULL,
  career text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

-- Allow public read access to certificates
CREATE POLICY "Certificates are viewable by everyone"
  ON certificates
  FOR SELECT
  TO public
  USING (true);

-- Allow authenticated users to create certificates
CREATE POLICY "Authenticated users can create certificates"
  ON certificates
  FOR INSERT
  TO authenticated
  WITH CHECK (true);