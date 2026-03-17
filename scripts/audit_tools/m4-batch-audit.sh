#!/bin/bash
# M4 视觉审计系统 (最终版) - 自动引擎定稿版

OUTPUT_DIR="audit_results"
mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
videos=( *.mp4 )

if [ ${#videos[@]} -eq 0 ]; then
    echo "❌ 错误: 未发现视频。请 cd 到视频所在目录。"
    exit 1
fi

# 核心设定：使用 auto 让 CLI 自主选择最佳多模态模型
MODEL="auto"

echo "🚀 M4 视觉审计系统启动... (模式: 自动引擎匹配)"

for video in "${videos[@]}"; do
    json_name="${video%.*}.json"
    echo "🔍 正在分析: $video ..."

    # 使用标准管道流传递指令，彻底解决参数冲突
    cat << INSTRUCTION | gemini --yolo -m "$MODEL" "$video" > "$OUTPUT_DIR/$json_name" 2>audit_error.log
你是一名资深显卡维修专家。请分析视频 $video，提取以下维修节点及对应时间戳：
- 阻值测量
- 核心植锡
- 显存屏蔽/测试
要求：使用中文输出，严格遵守 JSON 格式。
INSTRUCTION

    if [ $? -eq 0 ] && [ -s "$OUTPUT_DIR/$json_name" ]; then
        echo "✅ 审计成功: $json_name"
    else
        echo "❌ 审计失败: $video"
        # 如果 auto 还报错，打印具体的 API 响应
        echo "   错误原因: $(grep -i "error" audit_error.log | head -n 1)"
        rm -f "$OUTPUT_DIR/$json_name"
    fi
done

echo "🏁 审计任务处理完毕。"
