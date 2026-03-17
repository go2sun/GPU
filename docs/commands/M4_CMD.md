# M4 常用命令归宗表
- **同步命令**: `syncm4` 或 `syncgpu`
- **审计命令**: `gemini -p "分析 ./data/logs 中的报错"`
- **初始化**: `bash scripts/sync_tools/m4-gpu-init.sh`
1. 系统规划研究 (Planning)
Bash
# 扫描当前 GPU 目录并请求架构优化建议
tree -L 3 /Volumes/Ventoy/GPU | gemini -p "评估此 GPU 维修目录的逻辑结构，针对 1070/4090 的资料分布给出优化建议。"
2. 代码审计与集中管理 (Code Audit)
Bash
# 对所有的 .py 脚本进行统一审查
cat /Volumes/Ventoy/GPU/scripts/**/*.py | gemini -p "分析这些 Python 脚本的冗余度，并根据 M4 审计标准建议如何重构为模块化工具。"
3. 自动化同步命令 (Sync Integration)
Bash
# 结合之前定义的 syncm4 逻辑
# syncm4 会自动读取此命令并执行同步
gh project item-create [PROJECT_ID] --title "GPU 目录深度更新" --body "执行了脚本重构与资料归档。"