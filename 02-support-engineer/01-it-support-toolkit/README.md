# IT Support diagnostics

A Bash-based diagnostic tool for basic troubleshooting of a macOS workstation.

## Overview

This project automates a set of initial checks that can be useful for first-line IT support.

The script collects system information and checks basic network connectivity, DNS resolution, network interfaces, and disk usage.

## Features

### System information

- Current username
- Hostname
- macOS version
- CPU architecture
- Kernel version

### Network diagnostics

- Local IPv4 address
- Default gateway
- Gateway availability
- IPv4 connectivity
- HTTPS connectivity
- System DNS resolution
- External DNS resolution
- IPv6 connectivity
- Tunnel interface detection

### Disk diagnostics

- Root filesystem usage
- Disk space status

## Technologies

- Bash
- macOS Terminal
- `ifconfig`
- `netstat`
- `ping`
- `curl`
- `nslookup`
- `scutil`
- `df`
- `awk`

## Usage

Make the script executable:

```bash
chmod +x support-check.sh

Run the diagnostic tool:

```bash
./support-check.sh

#EXAMPLE
======================================
       IT SUPPORT DIAGNOSTICS v2
======================================

[USER]
Username: jasmin
Hostname: MacBook-Air-Jasmin.local

[SYSTEM]
OS: macOS
Version: 26.5.1
Architecture: arm64
Kernel: 25.5.0

[NETWORK]
[OK] IP address: 192.168.0.213
[OK] Gateway is reachable
[OK] HTTPS connectivity works

[DNS]
Configured DNS: 192.168.0.1
[WARNING] System DNS resolution failed

[IP CONNECTIVITY]
[OK] IPv4 connectivity works
[WARNING] IPv6 connectivity unavailable

[NETWORK INTERFACES]
[WARNING] Tunnel interface detected: utun6
[OK] External DNS (8.8.8.8) works

[DISK]
Root filesystem usage: 23%
[OK] Disk space is sufficient
[SUMMARY]
[OK] Gateway: reachable
[OK] IPv4 Internet: available
[WARNING] System DNS: not responding
[OK] External DNS: working
[WARNING] IPv6: unavailable
[OK] Tunnel: not detected

======================================
Diagnostics completed.
======================================

#Diagnostic workflow
The script follows a basic troubleshooting workflow:
Identify the workstation and operating system.
Check the local network configuration.
Check the default gateway.
Test connectivity to the gateway.
Test external HTTPS connectivity.
Check DNS resolution.
Check IPv4 and IPv6 connectivity.
Check for tunnel interfaces.
Check disk usage.
Display a diagnostic summary.
This helps perform initial troubleshooting before deeper investigation is required.

#Limitations
The current version is designed for macOS.
