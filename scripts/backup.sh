#!/usr/bin/env bash
# ===== BACKUP SAMCODER — SATU FOLDER BESAR, DUA MESIN =====
# Backup seluruh /home/farrah/samcoder (platform + engine config + data volume)
# Dibuat Aaron 14 Agu 2026 — prinsip: satu folder, satu backup, restore gampang
# Diperbarui Aaron 17 Agu 2026: tambah backup volume agent-data (sessions) & workspace (artefak)
set -e

TS=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=/home/farrah/backups/samcoder
mkdir -p "$BACKUP_DIR"

echo "=== BACKUP SAMCODER $TS ==="

# 1. Kode + config engine (folder besar, exclude git & node_modules)
tar czf "$BACKUP_DIR/samcoder_code_$TS.tar.gz" \
  --exclude=/home/farrah/samcoder/.git \
  --exclude=/home/farrah/samcoder/prime-engine/node_modules \
  -C /home/farrah samcoder 2>/dev/null
echo "OK kode+config: samcoder_code_$TS.tar.gz"

# 2. Data volume (users, orders, coupons, config, sessions registry)
docker run --rm -v prime-agent-hub_prime-hub-data:/data:ro -v "$BACKUP_DIR":/backup \
  alpine tar czf "/backup/samcoder_data_$TS.tar.gz" -C /data . 2>/dev/null
echo "OK data: samcoder_data_$TS.tar.gz"

# 2b. Volume agent-data (sessions JSONL + kernel venv — paling penting)
docker run --rm -v prime-agent-hub_prime-agent-data:/data:ro -v "$BACKUP_DIR":/backup \
  alpine tar czf "/backup/samcoder_sessions_$TS.tar.gz" -C /data . 2>/dev/null
echo "OK sessions: samcoder_sessions_$TS.tar.gz"

# 2c. Volume workspace (artefak hasil kerja agent)
docker run --rm -v prime-agent-hub_prime-workspace:/data:ro -v "$BACKUP_DIR":/backup \
  alpine tar czf "/backup/samcoder_workspace_$TS.tar.gz" -C /data . 2>/dev/null
echo "OK workspace: samcoder_workspace_$TS.tar.gz"

# 3. Retensi: simpan 7 hari terakhir
find "$BACKUP_DIR" -name "samcoder_*_*.tar.gz" -mtime +7 -delete 2>/dev/null || true

echo "=== SELESAI → $BACKUP_DIR ==="
ls -lh "$BACKUP_DIR" | tail -6
