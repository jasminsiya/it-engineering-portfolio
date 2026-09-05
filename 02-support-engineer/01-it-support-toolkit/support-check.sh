#!/bin/bash

echo "======================================"
echo "       IT SUPPORT DIAGNOSTICS v2"
echo "======================================"

OK="[OK]"
WARNING="[WARNING]"
ERROR="[ERROR]"
IPV4_OK=false
DNS_OK=false
EXTERNAL_DNS_OK=false
IPV6_OK=false
TUNNEL_FOUND=false
GATEWAY_OK=false
echo ""
echo "[USER]"
echo "Username: $(whoami)"
echo "Hostname: $(hostname)"

echo ""
echo "[SYSTEM]"
echo "OS: $(sw_vers -productName)"
echo "Version: $(sw_vers -productVersion)"
echo "Architecture: $(uname -m)"
echo "Kernel: $(uname -r)"

echo ""
echo "[NETWORK]"

# Get IPv4 address
IP_ADDRESS=$(ifconfig en0 | awk '/inet / && $2 != "127.0.0.1" {print $2; exit}')

if [ -n "$IP_ADDRESS" ]; then
    echo "$OK IP address: $IP_ADDRESS"
else
    echo "$ERROR IP address not found"
fi

# Get default gateway on physical interface
GATEWAY=$(netstat -rn | awk '$1 == "default" && $4 == "en0" {print $2; exit}')

if [ -n "$GATEWAY" ] && ping -c 2 -W 1000 "$GATEWAY" > /dev/null 2>&1; then
    echo "$OK Gateway is reachable"
    GATEWAY_OK=true
else
    echo "$ERROR Gateway is not reachable"
fi


# Test HTTPS connectivity
if curl -4 -I --max-time 5 -s https://www.google.com > /dev/null 2>&1; then
    echo "$OK HTTPS connectivity works"
    HTTPS_OK=true
else
    echo "$ERROR HTTPS connectivity failed"
fi
echo ""

echo "[DNS]"

DNS_SERVER=$(scutil --dns | awk '/nameserver/ {print $3; exit}')

if [ -n "$DNS_SERVER" ]; then
    echo "Configured DNS: $DNS_SERVER"
else
    echo "$ERROR DNS server not found"
fi

if nslookup google.com > /dev/null 2>&1; then
    echo "$OK System DNS resolution works"
    DNS_OK=true
else
    echo "$WARNING System DNS resolution failed"
fi
echo ""

echo "[IP CONNECTIVITY]"

if curl -4 -I --max-time 5 -s https://www.google.com > /dev/null 2>&1; then
    echo "$OK IPv4 connectivity works"
    IPV4_OK=true
else
    echo "$ERROR IPv4 connectivity failed"
fi

if curl -6 -I --max-time 5 -s https://www.google.com > /dev/null 2>&1; then
    echo "$OK IPv6 connectivity works"
    IPV6_OK=true
else
    echo "$WARNING IPv6 connectivity unavailable"
fi
echo ""

echo "[NETWORK INTERFACES]"

if ifconfig utun6 > /dev/null 2>&1; then
    echo "$WARNING Tunnel interface detected: utun6"
else
    echo "$OK No utun6 tunnel interface detected"
fi
if nslookup google.com 8.8.8.8 > /dev/null 2>&1; then
    echo "$OK External DNS (8.8.8.8) works"
    EXTERNAL_DNS_OK=true
else
    echo "$ERROR External DNS (8.8.8.8) failed"
fi
echo ""
echo "[DISK]"

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Root filesystem usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -lt 80 ]; then
    echo "$OK Disk space is sufficient"
elif [ "$DISK_USAGE" -lt 90 ]; then
    echo "$WARNING Disk usage is high"
else
    echo "$ERROR Disk usage is critical"
fi
echo ""
echo "[SUMMARY]"

if $GATEWAY_OK; then
    echo "$OK Gateway: reachable"
else
    echo "$ERROR Gateway: unreachable"
fi

if $HTTPS_OK; then
    echo "$OK IPv4 Internet: available"
else
    echo "$ERROR IPv4 Internet: unavailable"
fi

if $DNS_OK; then
    echo "$OK System DNS: working"
else
    echo "$WARNING System DNS: not responding"
fi

if $EXTERNAL_DNS_OK; then
    echo "$OK External DNS: working"
else
    echo "$ERROR External DNS: unavailable"
fi

if $IPV6_OK; then
    echo "$OK IPv6: available"
else
    echo "$WARNING IPv6: unavailable"
fi

if $TUNNEL_FOUND; then
    echo "$WARNING Tunnel: utun6 detected"
else
    echo "$OK Tunnel: not detected"
fi

echo ""
echo "======================================"
echo "Diagnostics completed."
echo "======================================"
