sudo find var/tmp -mindepth 1 ! -name '.gitignore' -type f -or -type d -exec rm -rf {} +
sudo find var/log -mindepth 1 ! -name '.gitignore' -type f -or -type d -exec rm -rf {} +
