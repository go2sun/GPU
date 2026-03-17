#!/bin/bash
# M4 视觉审计系统 - 磁盘清理模块
# 目标：删除 0 字节视频及 macOS 缓存文件

TARGET_DIR="/Volumes/Ventoy/GPU/显卡维修_72"

echo "🔍 正在扫描异常文件..."

# 1. 删除所有 0 字节的 .mp4 文件
find "$TARGET_DIR" -name "*.mp4" -size 0 -print -delete

# 2. 删除 macOS 产生的 ._ 开头的隐藏文件
find "$TARGET_DIR" -name "._*" -print -delete

echo "✅ 清理完成。无效的 slim_ 占位符已移除。"
