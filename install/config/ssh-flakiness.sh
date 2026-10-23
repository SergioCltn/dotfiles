# Solve common flakiness with SSH
echo "net.ipv4.tcp_mtu_probing=1" | sudo tee /etc/sysctl.d/90-tcp-mtu-probing.conf >/dev/null
