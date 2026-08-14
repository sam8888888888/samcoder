# SAMCODER — Satu Folder Besar, Dua Mesin

```
/home/farrah/samcoder/
├── samcoder/          ← PAKET 1: Platform SAMCODER (produk komersial Papi)
│   ├── backend/       ← server.js, export_answers.py, package.json
│   └── frontend/      ← landing, daftar, konfirmasi, thankyou, admin, styles
├── prime-engine/      ← PAKET 2: Prime Agent mesin (dependency PINNED v0.7.2)
│   └── package.json   ← "prime-agent": "0.7.2"
├── caddy/             ← reverse proxy + rate limit
├── Dockerfile         ← build: engine global + SAMCODER /app
├── docker-compose.yml
├── .env               ← secret (JANGAN commit / jangan backup publik)
├── scripts/backup.sh  ← backup 1 folder → 2 file (kode+config, data)
└── README.md
```

## Cara Backup
```bash
bash /home/farrah/samcoder/scripts/backup.sh
# → /home/farrah/backups/samcoder/samcoder_code_<ts>.tar.gz
# → /home/farrah/backups/samcoder/samcoder_data_<ts>.tar.gz
```

## Cara Restore
```bash
# 1. Kode
tar xzf samcoder_code_<ts>.tar.gz -C /home/farrah
# 2. Data (volume)
docker run --rm -v prime-agent-hub_prime-hub-data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/samcoder_data_<ts>.tar.gz -C /data
# 3. Jalanin
cd /home/farrah/samcoder && docker compose up -d --build
```

## Aturan
- **Prime Agent engine v0.7.2 PINNED** — update hanya kalau sudah dites penuh
- **Lisensi MIT** (PrimeIntellect) — atribusi "Powered by Prime Agent" menyusul saat live komersial
- Data volume: `prime-agent-hub_prime-hub-data` (users, orders, coupons, config, login-sessions)
