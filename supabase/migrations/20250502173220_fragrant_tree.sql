-- Drop existing trigger first
DROP TRIGGER IF EXISTS set_certificate_date_trigger ON certificates;

-- Drop existing functions to avoid conflicts
DROP FUNCTION IF EXISTS format_certificate_date(timestamptz) CASCADE;
DROP FUNCTION IF EXISTS get_friday_between_march_10_20(integer) CASCADE;
DROP FUNCTION IF EXISTS set_certificate_date() CASCADE;

-- Create function to format date as DD-MM-YYYY
CREATE FUNCTION format_certificate_date(date_value timestamptz)
RETURNS text AS $$
BEGIN
    RETURN to_char(date_value AT TIME ZONE 'UTC', 'DD-MM-YYYY');
END;
$$ LANGUAGE plpgsql;

-- Create function to find Friday between March 10-20 for a given year
CREATE FUNCTION get_friday_between_march_10_20(year integer)
RETURNS date AS $$
DECLARE
    start_date date;
    end_date date;
    check_date date;
BEGIN
    -- Validate year input
    IF year IS NULL OR year < 1900 OR year > 2100 THEN
        RETURN NULL;
    END IF;

    -- Set start and end dates
    start_date := make_date(year, 3, 10);
    end_date := make_date(year, 3, 20);
    
    -- Start from March 10
    check_date := start_date;
    
    -- Find the first Friday after March 10
    WHILE EXTRACT(DOW FROM check_date) != 5 AND check_date <= end_date LOOP
        check_date := check_date + interval '1 day';
    END LOOP;
    
    -- If we went past March 20, go back a week
    IF check_date > end_date THEN
        check_date := check_date - interval '7 days';
    END IF;
    
    RETURN check_date;
END;
$$ LANGUAGE plpgsql;

-- Create trigger function
CREATE FUNCTION set_certificate_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.graduation_year IS NOT NULL AND 
       NEW.graduation_year BETWEEN 1900 AND 2100 THEN
        NEW.fecha_certificado := get_friday_between_march_10_20(NEW.graduation_year);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER set_certificate_date_trigger
    BEFORE INSERT OR UPDATE OF graduation_year ON certificates
    FOR EACH ROW
    EXECUTE FUNCTION set_certificate_date();

-- Update existing certificates
UPDATE certificates
SET fecha_certificado = get_friday_between_march_10_20(graduation_year)
WHERE graduation_year IS NOT NULL 
  AND graduation_year BETWEEN 1900 AND 2100;

-- Update specific certificate
UPDATE certificates 
SET fecha_certificado = '2023-03-11'::date
WHERE id = 1746193857;