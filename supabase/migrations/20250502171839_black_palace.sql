/*
  # Update Certificate Date Format and Display
  
  1. Changes
    - Create function to format dates as DD-MM-YYYY
    - Update certificates to use proper date format
*/

-- Create function to format date as DD-MM-YYYY
CREATE OR REPLACE FUNCTION format_certificate_date(date_value timestamptz)
RETURNS text AS $$
BEGIN
    RETURN to_char(date_value AT TIME ZONE 'UTC', 'DD-MM-YYYY');
END;
$$ LANGUAGE plpgsql;