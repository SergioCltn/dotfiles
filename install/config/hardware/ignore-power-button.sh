# Disable shutting system down on power button to bind it to power menu afterwards
sudo mkdir -p /etc/systemd/logind.conf.d
printf '[Login]\nHandlePowerKey=ignore\n' | sudo tee /etc/systemd/logind.conf.d/power-button.conf >/dev/null
