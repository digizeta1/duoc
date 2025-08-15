/*
  # Fix certificates sequence and auto-increment

  1. Changes
    - Drop and recreate sequence with proper settings
    - Reset column configuration
    - Ensure proper constraints and permissions
    - Reset sequence value

  2. Notes
    - Ensures proper auto-increment functionality
    - Maintains data integrity
    - Fixes the duplicate key issue
*/

-- Drop existing sequence if it exists
DROP SEQUENCE IF EXISTS certificates_id_seq CASCADE;

-- Create new sequence with proper settings
CREATE SEQUENCE certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Drop existing primary key constraint
ALTER TABLE certificates 
    DROP CONSTRAINT IF EXISTS certificates_pkey;

-- Reset the id column configuration
ALTER TABLE certificates
    ALTER COLUMN id DROP DEFAULT,
    ALTER COLUMN id DROP NOT NULL;

-- Set up the id column properly
ALTER TABLE certificates
    ALTER COLUMN id SET DATA TYPE bigint USING (CASE 
        WHEN id IS NULL THEN nextval('certificates_id_seq')
        ELSE id::bigint 
    END),
    ALTER COLUMN id SET DEFAULT nextval('certificates_id_seq'),
    ALTER COLUMN id SET NOT NULL;

-- Re-add primary key constraint
ALTER TABLE certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);

-- Set proper sequence ownership
ALTER SEQUENCE certificates_id_seq OWNED BY certificates.id;

-- Reset sequence to proper value
SELECT setval('certificates_id_seq', COALESCE((SELECT MAX(id) FROM certificates), 0) + 1, false);

-- Grant necessary permissions
GRANT USAGE, SELECT ON SEQUENCE certificates_id_seq TO public;