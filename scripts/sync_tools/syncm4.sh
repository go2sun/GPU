#!/bin/bash
REPO_DIR="$HOME/M4_Repo"
cd "$REPO_DIR" || exit
echo "🔄 [M4 同步] 准备对齐云端资产..."
git add .
git commit -m "M4-Audit: 系统自愈与资产同步 ($(date +'%Y-%m-%d %H:%M'))"
git push origin main
echo "✅ [M4 归位] 数据已安全存入 GitHub。"
