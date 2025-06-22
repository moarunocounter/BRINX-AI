# BrinxAI Worker & Relay Node Installer

Skrip interaktif ini memudahkan kamu untuk menginstal dan menjalankan node Worker serta Relay untuk proyek **BrinxAI** berbasis Docker.

---

## ⚙️ Fitur

- Instalasi Docker otomatis
- Konfigurasi firewall & port penting
- Clone dan instalasi BrinxAI Worker Nodes
- Jalankan berbagai model AI: Stable Diffusion, Upscaler, Text UI, Rembg
- Instalasi dan pengecekan Relay Container

---

## 🚀 Cara Pakai

```bash
wget https://github.com/moarunocounter/BRINX-AI && chmod +x brinxai.sh && ./brinxai.sh
```

---

## 🧭 Menu Interaktif

Saat menjalankan skrip, kamu akan melihat menu seperti ini:

```text
1. Install Docker
2. Enable Docker Service
3. Setup Firewall & Allow Ports
4. Clone BrinxAI Worker Repo & Install
5. Run Worker Models (Stable Diff, Upscaler, etc)
6. Run Relay Container
0. Exit
```

---

## 🤖 Model AI yang Didukung

| Nama Model         | Port       | CPU | RAM     |
|--------------------|------------|-----|---------|
| Stable Diffusion   | `5060`     | 6   | 8 GB    |
| Upscaler           | `3800`     | 2   | 8 GB    |
| Text UI            | `5012`     | 4   | 8 GB    |
| Rembg              | `7000`     | 2   | 4 GB    |

> Semua container berjalan di `localhost` dan jaringan Docker: `brinxai-network`

---

## 🔐 Firewall & Akses

Skrip akan membuka port:
- `5011/tcp` (untuk layanan UI / akses container)
- `1194/udp` (jika diperlukan)
- `OpenSSH` tetap aktif

---

## 🧑‍💻 Developer

- Telegram: [@airdropalc](https://t.me/airdropalc)
- Script by: **MOARU**

---

## ✅ Catatan Tambahan

- Pastikan OS: **Ubuntu 20.04+**
- Jalankan sebagai user dengan akses `sudo`
- Tidak cocok untuk layanan shared hosting

---

Selamat bereksperimen dengan AI lokal 💻✨
