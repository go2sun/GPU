#!/bin/bash
# M4 视觉审计系统 - GPU 目录自动化重构工具

TARGET_DIR="/Volumes/Ventoy/GPU"
cd "$TARGET_DIR" || exit

echo "🏗️ [M4 系统] 开始自动化目录规化..."

# 1. 批量创建标准目录架构
mkdir -p .m4_audit \
         scripts/{audit_tools,sync_tools,maintenance} \
         docs/{planning,commands,repair_guides} \
         data/{schematics,boardview,logs}

# 2. 自动化文件归类 (根据后缀名和关键字)
echo "📂 正在执行物理归类..."

# 移动所有 Python 和 Shell 脚本
find . -maxdepth 1 -name "*.py" -exec mv {} scripts/maintenance/ \;
find . -maxdepth 1 -name "*.sh" -exec mv {} scripts/sync_tools/ \;

# 移动文档类文件
mv *.md docs/planning/ 2>/dev/null
mv *.pdf docs/repair_guides/ 2>/dev/null

# 移动数据类文件 (常见的电路图格式)
mv *.pdf data/schematics/ 2>/dev/null
mv *.brd *.bv *.cad data/boardview/ 2>/dev/null
mv mats*.txt report*.txt data/logs/ 2>/dev/null

# 3. 自动生成 .geminiignore (防止扫描大体积视频)
cat <<EOF > .geminiignore
*.mp4
*.mov
*.zip
*.bin
.git/
node_modules/
EOF

# 4. 自动生成命令归宗文档
cat <<EOF > docs/commands/M4_CMD.md
# M4 常用命令归宗表
- **同步命令**: \`syncm4\` 或 \`syncgpu\`
- **审计命令**: \`gemini -p "分析 ./data/logs 中的报错"\`
- **初始化**: \`bash scripts/sync_tools/m4-gpu-init.sh\`
EOF

echo "✨ [M4 系统] 目录规化完成！所有文件已自动对齐。"
tree -L 3