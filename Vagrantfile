Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # Port forwarding
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 5432, host: 5432

  # 同步資料夾：host 的 project 目錄 <-> VM 的 /home/vagrant/project
  config.vm.synced_folder "./project", "/home/vagrant/project"

  # 自動初始化 bootstrap.sh
  config.vm.provision "shell", path: "bootstrap.sh"

  # 自動啟動 Docker
  config.vm.provision "shell", inline: <<-SHELL
    sudo systemctl enable docker
    sudo systemctl start docker
  SHELL
end