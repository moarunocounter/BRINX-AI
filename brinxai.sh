#!/bin/bash
clear
HEADER_WIDTH=50
TITLE="AIRDROP LEGION"
TELEGRAM="@airdropalc"
PADDING=$(( (HEADER_WIDTH - ${#TITLE}) / 2 ))
PADDING2=$(( (HEADER_WIDTH - ${#TELEGRAM} - 9) / 2 ))

printf '=%.0s' $(seq 1 $HEADER_WIDTH); echo
printf "%*s%s\n" $PADDING "" "$TITLE"
printf "%*s%s\n" $PADDING2 "" "Telegram $TELEGRAM"
printf '=%.0s' $(seq 1 $HEADER_WIDTH); echo
echo    # <– ini satu baris kosong aja, cukup

set -e

function print_menu() {
  echo -e "\n=== BrinxAI Worker Node Installer ==="
  echo "1. Install Docker"
  echo "2. Enable Docker Service"
  echo "3. Setup Firewall & Allow Ports"
  echo "4. Clone BrinxAI Worker Repo & Install"
  echo "5. Run Worker Models (Stable Diff, Upscaler, etc)"
  echo "6. Run Relay Container"
  echo "0. Exit"
  echo -n "Pilih opsi: "
}

function install_docker() {
  echo "[+] Installing Docker..."
  sudo apt update
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
}

function enable_docker() {
  echo "[+] Enabling Docker service..."
  sudo systemctl start docker
  sudo systemctl enable docker
}

function setup_firewall() {
  echo "[+] Setting up UFW..."
  sudo ufw allow OpenSSH
  sudo ufw allow 5011/tcp
  sudo ufw allow 1194/udp
  sudo ufw --force enable
}

function install_worker_repo() {
  echo "[+] Cloning BrinxAI Worker Repo..."
  git clone https://github.com/admier1/BrinxAI-Worker-Nodes || echo "[!] Repo sudah ada, skip clone"
  cd BrinxAI-Worker-Nodes
  chmod +x install_ubuntu.sh
  ./install_ubuntu.sh
  cd ..
}

function run_models() {
  echo "[+] Menjalankan Docker containers untuk model..."
  docker network inspect brinxai-network >/dev/null 2>&1 || docker network create brinxai-network

  docker run -d --name stable-diffusion --network brinxai-network --cpus=6 --memory=8192m \
    -p 127.0.0.1:5060:5060 -e PORT=5060 admier/brinxai_nodes-stabled:latest

  docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=8192m \
    -p 127.0.0.1:3800:3800 admier/brinxai_nodes-upscaler:latest

  docker run -d --name text-ui --network brinxai-network --cpus=4 --memory=8192m \
    -p 127.0.0.1:5012:5012 admier/brinxai_nodes-text-ui:latest

  docker run -d --name rembg --network brinxai-network --cpus=2 --memory=4096m \
    -p 127.0.0.1:7000:7000 admier/brinxai_nodes-rembg:latest
}

function run_relay() {
  echo "[+] Menjalankan BrinxAI Relay..."
  sudo docker run -d --name brinxai_relay --cap-add=NET_ADMIN -p 1194:1194/udp \
    admier/brinxai_nodes-relay:latest
}

while true; do
  print_menu
  read choice
  case $choice in
    1) install_docker ;;
    2) enable_docker ;;
    3) setup_firewall ;;
    4) install_worker_repo ;;
    5) run_models ;;
    6) run_relay ;;
    0) echo "Bye bosku 👋"; exit 0 ;;
    *) echo "Opsi nggak valid, coba lagi." ;;
  esac
done
