#!/bin/bash
# M4 视觉审计系统 - GPU 维修深度关联工具

echo "🔍 [M4 系统] 正在对 GPU 目录进行深度逻辑建模与关联..."

# 1. 扫描并分类文件
# 我们重点关注 1070 和 4090 的相关文档
PDF_FILES=$(find ./GPU -name "*1070*" -o -name "*4090*" | grep ".pdf")
REPAIR_LOGS=$(find ./GPU -name "*.md" -o -name "*.txt")

# 2. 构建深度研究提示词
PROMPT_HEADER="你现在是电子工程专家。请执行以下任务：
1. 交叉对比：分析维修日志中的报错（如 MATS 报错位）与提供的 PDF 电路图中的元件编号（如 U1, Q500）是否有逻辑关联。
2. 学习路径：基于 1070 到 4090 的技术演进（供电相数增加、显存协议变化），规划一条学习路径。
3. 视觉审计映射：建立一个全景视图，说明当出现 'Code 43' 或 '显存报错' 时，应优先在目录中查看哪些文档。"

# 3. 汇总数据并投喂
{
    echo "$PROMPT_HEADER"
    echo -e "\n--- 目录架构 ---"
    tree ./GPU -L 3
    
    echo -e "\n--- 维修日志摘录 ---"
    for log in $REPAIR_LOGS; do
        echo "日志文件: $log"
        cat "$log" | head -n 30
    done

    echo -e "\n--- 电路图元数据 ---"
    for pdf in $PDF_FILES; do
        echo "找到关键参考图: $(basename "$pdf")"
    done
} | gemini -p "执行 GPU 维修知识库深度关联研究"

echo "✨ [M4 系统] 关联报告已生成，建议将其存入 /docs/repair_map.md"