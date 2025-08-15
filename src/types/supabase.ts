export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      certificates: {
        Row: {
          id: number
          name: string
          rut: string | null
          career: string | null
          graduation_year: number | null
          whatsapp: string | null
          estado: string
          created_at: string | null
          qr_url: string | null
          view_url: string | null
          fecha_certificado: string | null
        }
        Insert: {
          id?: number
          name: string
          rut?: string | null
          career?: string | null
          graduation_year?: number | null
          whatsapp?: string | null
          estado?: string
          created_at?: string | null
          qr_url?: string | null
          view_url?: string | null
          fecha_certificado?: string | null
        }
        Update: {
          id?: number
          name?: string
          rut?: string | null
          career?: string | null
          graduation_year?: number | null
          whatsapp?: string | null
          estado?: string
          created_at?: string | null
          qr_url?: string | null
          view_url?: string | null
          fecha_certificado?: string | null
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}