# BRINX-AI

Automated installer for BrinxAI Worker Nodes.  
Supports Docker setup, firewall configuration, repository cloning, model deployment, and relay runner in a single script.

---

## ⚙️ Fitur Utama

- **Instalasi Otomatis**: Menyiapkan semua komponen BrinxAI Worker Node secara otomatis.
- **Setup Docker**: Mengonfigurasi Docker untuk menjalankan container BrinxAI.
- **Firewall Configuration**: Mengatur aturan firewall untuk keamanan.
- **Cloning Repository**: Mengkloning repository yang diperlukan untuk operasi.
- **Model Deployment**: Menyebarkan model AI ke worker node.
- **Relay Runner**: Mengonfigurasi relay runner untuk komunikasi antar node.

---

## 🚀 Cara Penggunaan

1. Login/Buat akun dengan email yang sama seperti sebelumnya
   https://brinxai.com/dashboard

2. Masuk ke VPS & Buat screen

   ```bash
   screen -S brinxai
   ```

3. Clone Repo & Jalankan sesuai urutan

   ```bash
   git clone https://github.com/moarunocounter/BRINX-AI.git && cd BRINX-AI && chmod +x brinxai.sh && ./brinxai.sh
   ```
   
4. Cek docker logs
   
   ```bash
   docker logs -f "container id"
   ```
---
## OFFICIAL GUIDE
  https://brinxai.gitbook.io/brinxai-depin-ai
