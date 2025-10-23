#!/bin/bash
set -e

echo "=== Iniciando OpenVPN ==="

# Iniciar OpenVPN en segundo plano
openvpn --config /etc/openvpn/config.ovpn --daemon tun0 --status /tmp/openvpn-status.log 10 --log /tmp/openvpn.log --verb 3

echo "Esperando que OpenVPN se estabilice..."
sleep 15

# Verificar si OpenVPN está conectado
if [ ! -f /tmp/openvpn-status.log ]; then
    echo "ERROR: OpenVPN no se inició"
    sleep 3
    tail -n 50 /tmp/openvpn.log || echo "No log available"
    exit 1
fi

echo "=== OpenVPN iniciado correctamente ==="
echo "=== Iniciando n8n ==="

exec n8n start
