FROM node:18

# Instalar OpenVPN y herramientas necesarias
RUN apt-get update && apt-get install -y \
    openvpn \
    postgresql-client \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio para OpenVPN
RUN mkdir -p /etc/openvpn

# Copiar configuración OpenVPN
COPY config.ovpn /etc/openvpn/config.ovpn

# Instalar n8n
RUN npm install -g n8n

# Script de inicio
RUN echo '#!/bin/bash\n\
set -e\n\
echo "=== Iniciando OpenVPN ==="\n\
openvpn --config /etc/openvpn/config.ovpn --daemon --log /var/log/openvpn.log\n\
echo "Esperando conexión VPN..."\n\
sleep 10\n\
echo "=== OpenVPN iniciado ==="\n\
echo "=== Iniciando n8n ==="\n\
exec n8n start\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 5678

CMD ["/start.sh"]
