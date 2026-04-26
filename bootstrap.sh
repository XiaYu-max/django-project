#!/usr/bin/env bash
# bootstrap.sh — Vagrant VM 初始化腳本
# 由 Vagrantfile 自動呼叫，只需在第一次 vagrant up 時執行一次。
# 作用：在 VM 裡安裝 Docker，其餘設定由 project/ 的 docker-compose.yml 控制。

set -e

echo "=== [1/3] 更新系統套件 ==="
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "=== [2/3] 安裝 Docker ==="
if ! command -v docker &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Docker 安裝完成"
else
    echo "Docker 已安裝，跳過"
fi

echo "=== [3/3] 啟動 Docker 服務 ==="
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker vagrant || true

echo ""
echo "=== Bootstrap 完成 ==="
echo "請執行以下指令啟動專案："
echo "  cd /home/vagrant/project && docker compose up -d"