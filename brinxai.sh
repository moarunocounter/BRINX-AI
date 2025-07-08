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
echo

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
  if command -v docker >/dev/null 2>&1; then
    echo "[✓] Docker sudah terinstall, skip."
    return
  fi

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
  echo "[+] Mengecek dan mengatur firewall UFW..."

  if ! command -v ufw >/dev/null 2>&1; then
    echo "[+] Menginstall UFW..."
    sudo apt-get install ufw -y
  fi

  echo "[+] Mengatur aturan firewall..."
  sudo ufw allow OpenSSH
  sudo ufw allow 5011/tcp
  sudo ufw allow 1194/udp

  echo "[+] Mengaktifkan UFW..."
  sudo ufw --force enable

  echo "[+] Status firewall saat ini:"
  sudo ufw status
}

function install_worker_repo() {
  echo "[+] Cloning BrinxAI Worker Repo..."
  if [ ! -d "BrinxAI-Worker-Nodes" ]; then
    wget https://raw.githubusercontent.com/admier1/BrinxAI-Worker-Nodes/refs/heads/main/install_brinxai_worker_amd64_deb.sh
  else
    echo "[!] Folder BrinxAI-Worker-Nodes sudah ada, skip clone"
  fi

  cd BrinxAI-Worker-Nodes/refs/heads/main || { echo "[x] Gagal masuk ke direktori repo"; exit 1; }

  if [ ! -f install_brinxai_worker_amd64_deb.sh ]; then
    echo "[x] Script install_brinxai_worker_amd64.sh tidak ditemukan!"
    exit 1
  fi

  chmod +x install_brinxai_worker_amd64_deb.sh
  ./install_brinxai_worker_amd64_deb.sh || { echo "[x] Gagal menjalankan script installer"; exit 1; }

  cd ..
}

function run_models() {
  docker network inspect brinxai-network >/dev/null 2>&1 || docker network create brinxai-network

  while true; do
    echo -e "\n[+] Pilih model yang ingin dijalankan:"
    echo "1. Stable Diffusion"
    echo "2. Upscaler"
    echo "3. Text UI"
    echo "4. Rembg"
    echo "0. Kembali ke menu utama"
    echo -n "Pilih model: "
    read model_choice

    case $model_choice in
      1)
        echo "[+] Menjalankan Stable Diffusion..."
        docker run -d --name stable-diffusion --network brinxai-network --cpus=6 --memory=8192m \
          -p 127.0.0.1:5060:5060 -e PORT=5060 admier/brinxai_nodes-stabled:latest
        ;;
      2)
        echo "[+] Menjalankan Upscaler..."
        docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=8192m \
          -p 127.0.0.1:3800:3800 admier/brinxai_nodes-upscaler:latest
        ;;
      3)
        echo "[+] Menjalankan Text UI..."
        docker run -d --name text-ui --network brinxai-network --cpus=4 --memory=8192m \
          -p 127.0.0.1:5012:5012 admier/brinxai_nodes-text-ui:latest
        ;;
      4)
        echo "[+] Menjalankan Rembg..."
        docker run -d --name rembg --network brinxai-network --cpus=2 --memory=4096m \
          -p 127.0.0.1:7000:7000 admier/brinxai_nodes-rembg:latest
        ;;
      0)
        break
        ;;
      *)
        echo "[!] Pilihan tidak valid."
        ;;
    esac
  done
}

function run_relay() {
  echo "[+] Mengunduh dan menjalankan installer Relay (.deb)..."
  wget https://raw.githubusercontent.com/admier1/BrinxAI-Relay-Nodes/main/install_brinxai_relay_amd64_deb.sh || {
    echo "[x] Gagal mengunduh script DEB!"
    return 1
  }
  chmod +x install_brinxai_relay_amd64_deb.sh
  ./install_brinxai_relay_amd64_deb.sh || {
    echo "[x] Gagal menjalankan script DEB!"
    return 1
  }

  echo "[✓] Mengecek status kontainer relay..."
  docker ps -a --filter "name=brinxai_relay_amd64"

  echo "[✓] Menampilkan log kontainer relay (jika tidak berjalan)..."
  docker logs brinxai_relay_amd64 || echo "[i] Kontainer belum aktif atau log tidak tersedia."
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
    0) echo "Jangan lupa join Telegram juga ya 🫡"; exit 0 ;;
    *) echo "Opsi nggak valid, coba lagi." ;;
  esac
done
