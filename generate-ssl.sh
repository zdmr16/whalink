#!/bin/bash

# SSL Certificate Generator for Localhost
# ========================================

set -e

echo "🔐 Generating self-signed SSL certificate for localhost..."

# Create ssl directory if it doesn't exist
mkdir -p ssl

# Generate private key and certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/localhost.key \
  -out ssl/localhost.crt \
  -subj "/C=TR/ST=Istanbul/L=Istanbul/O=Whalink/OU=IT/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,DNS:*.localhost,IP:127.0.0.1"

# Set proper permissions
chmod 600 ssl/localhost.key
chmod 644 ssl/localhost.crt

echo "✅ SSL certificate generated successfully!"
echo ""
echo "📄 Certificate: ssl/localhost.crt"
echo "🔑 Private Key: ssl/localhost.key"
echo ""
echo "⚠️  Note: This is a self-signed certificate."
echo "    Your browser will show a security warning."
echo "    This is normal for development environments."
echo ""
echo "📖 To trust this certificate in your browser:"
echo "   - Chrome/Edge: Click 'Advanced' > 'Proceed to localhost (unsafe)'"
echo "   - Firefox: Click 'Advanced' > 'Accept the Risk and Continue'"
echo ""
