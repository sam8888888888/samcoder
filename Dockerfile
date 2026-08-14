# ===== SAMCODER PLATFORM + PRIME ENGINE (2 paket, 1 folder besar) =====
# Paket 2: Prime Agent engine v0.7.2 (PINNED — lisensi MIT, kredit menyusul saat live komersial)
# Paket 1: SAMCODER web (produk Papi)
FROM node:22-bookworm-slim

# Python + ipykernel dibutuhkan Prime Agent (IPython runtime)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Library ekspor jawaban (PDF/DOCX/XLSX) — Aaron 13 Agu 2026
RUN python3 -m pip install --no-cache-dir --break-system-packages reportlab python-docx openpyxl

# Paket 2: Install Prime Agent engine (release resmi v0.7.2 — VERSION PINNED, jangan ubah tanpa test)
RUN curl -fsSL https://app.primeintellect.ai/prime-agent/install.sh | sh

# Paket 1: SAMCODER backend + frontend
WORKDIR /app
COPY samcoder/backend/ /app/backend/
COPY samcoder/frontend/ /app/frontend/

# Workspace artefak (tempat Prime Agent bekerja & menyimpan file)
RUN mkdir -p /workspace && chmod 777 /workspace

EXPOSE 3000
CMD ["node", "/app/backend/server.js"]
