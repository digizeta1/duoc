# Certificados DuocUC - Sistema de Validación

Sistema oficial de validación de certificados DuocUC con verificación segura mediante códigos QR.

## 🚀 Características

- ✅ Validación de certificados por RUT
- 📱 Códigos QR para verificación
- 🔒 Seguridad con Supabase
- 📄 Generación de PDFs
- 📱 Diseño responsive

## 🛠️ Tecnologías

- **Frontend**: React + TypeScript + Vite
- **Styling**: Tailwind CSS
- **Base de datos**: Supabase
- **PDF**: jsPDF + html2canvas
- **QR**: qrcode
- **Deploy**: Netlify

## 🔧 Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/tu-usuario/certificados-duoc.git
cd certificados-duoc
```

2. Instala dependencias:
```bash
npm install
```

3. Configura variables de entorno:
```bash
cp .env.example .env
```

4. Ejecuta en desarrollo:
```bash
npm run dev
```

## 🌐 Deploy

El proyecto está configurado para deploy automático en Netlify.

### Variables de entorno requeridas:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 📝 Uso

1. **Validación**: Ingresa un RUT en `/ValidacionCertificados`
2. **Certificado**: Accede via QR o URL directa
3. **PDF**: Descarga el certificado en formato PDF

## 🔗 URLs

- **Producción**: https://certificadosvalidaduoc.cl
- **Validación**: `/ValidacionCertificados`
- **Certificado**: `/certificado/:id`
- **Vista**: `/ValidacionQr?id=:id`

## 📄 Licencia

© 2024 DuocUC - Todos los derechos reservados