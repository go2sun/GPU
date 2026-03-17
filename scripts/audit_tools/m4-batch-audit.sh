#!/bin/bash
SOURCE_DIR="/Volumes/Ventoy/GPU/显卡维修_72"
OUTPUT_DIR="$HOME/M4_Repo/data/cases"
mkdir -p "$OUTPUT_DIR"
echo "🚀 M4 批量审计系统启动..."
find "$SOURCE_DIR" -name "*.mp4" -size +0 -print0 | while IFS= read -r -d '' video; do
    filename=$(basename "$video")
    json_name="${filename%.*}.json"
    if [ -s "$OUTPUT_DIR/$json_name" ]; then
        echo "⏭️  跳过有效审计: $filename"
        continue
    fi
    echo "🔍 正在进行多模态分析: $filename ..."
    gemini --yolo -m gemini-2.5-flash -p "你是一名资深显卡维修审计员。分析此视频：\"$video\"。提取维修节点及时间戳。严格以 JSON 格式输出。" > "$OUTPUT_DIR/$json_name"
    if [ $? -eq 0 ]; then
        echo "✅ 审计成功: $json_name"
    else
        echo "❌ 审计失败: $filename"
        rm -f "$OUTPUT_DIR/$json_name"
    fi
done
echo "🏁 审计任务全量完成。"
