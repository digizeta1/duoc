/*
  # Create Storage Tables for Certificates

  1. Changes
    - Create tables for managing file storage
    - Set up appropriate security policies
    - Create bucket for certificates

  2. Security
    - Allow public read access to certificate files
    - Restrict write access to authenticated users only
*/

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS storage;

-- Create objects table
CREATE TABLE IF NOT EXISTS storage.objects (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    bucket_id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    last_accessed_at timestamptz DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/')) STORED,
    version text
);

-- Create buckets table
CREATE TABLE IF NOT EXISTS storage.buckets (
    id text PRIMARY KEY,
    name text NOT NULL,
    owner uuid,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[]
);

-- Add bucket for certificates
INSERT INTO storage.buckets (id, name, public)
VALUES ('certificates', 'certificates', true)
ON CONFLICT (id) DO NOTHING;

-- Enable RLS
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;
ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

-- Policies for buckets
CREATE POLICY "Public Access to Buckets"
ON storage.buckets FOR SELECT
TO public
USING (true);

-- Policies for objects
CREATE POLICY "Public Access to Objects"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'certificates');

CREATE POLICY "Authenticated Users Can Upload Objects"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'certificates');

-- Create indexes
CREATE INDEX IF NOT EXISTS objects_bucket_id_idx ON storage.objects (bucket_id);
CREATE INDEX IF NOT EXISTS objects_name_idx ON storage.objects (name);

-- Add foreign key constraint
ALTER TABLE storage.objects
ADD CONSTRAINT objects_buckets_fkey
FOREIGN KEY (bucket_id)
REFERENCES storage.buckets(id)
ON DELETE CASCADE;