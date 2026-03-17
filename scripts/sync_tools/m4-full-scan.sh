#!/bin/bash
# M4 视觉审计系统 - 全量技能扫描引擎

TARGET="/Volumes/Ventoy/GPU"
echo "📡 [M4 系统] 正在进行全量技能点扫描..."

# 1. 抓取目录树和所有文件列表
FILES_STRUCTURE=$(tree -L 3 "$TARGET" -I "node_modules|.git")

# 2. 提取关键视频和文档关键词
KEYWORDS=$(ls -R "$TARGET" | grep -E "1070|4090|电路|维修|显存|供电" | head -n 20)

# 3. 投喂给 Gemini CLI 进行“技能画像”
echo "🤖 正在通过 Gemini CLI 构建你的技能地图..."

echo "你现在是 M4 系统的技能审计官。请分析以下目录结构和文件：
$FILES_STRUCTURE

这些资料中包含了：
$KEYWORDS

请执行以下任务：
1. 识别出该目录涵盖的 3 个核心技术领域。
2. 挖掘出隐藏的'高阶挑战'（例如 4090 供电审计）。
3. 告诉我：根据目前的资料量，我离成为'Montreal 首席 GPU 维修专家'还有多远？" | gemini -p "执行全量技能审计"

echo "✨ [M4 系统] 审计报告已生成。建议查看输出并更新你的 GitHub Board。"