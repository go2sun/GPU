#!/bin/bash
# M4 视觉审计系统 - 递归增强版
SOURCE_DIR="/Volumes/Ventoy/GPU/显卡维修_72"
OUTPUT_DIR="$HOME/M4_Repo/data/cases"

mkdir -p "$OUTPUT_DIR"
echo "🚀 M4 递归审计启动... (正在扫描所有子文件夹)"

# 使用 -type f 递归查找所有子目录下的视频
find "$SOURCE_DIR" -name "*.mp4" -size +0 -print0 | while IFS= read -r -d '' video; do
    filename=$(basename "$video")
    # 为了避免重名，JSON 文件名包含父文件夹名缩写
    parent=$(basename "$(dirname "$video")")
    json_name="${parent}_${filename%.*}.json"
    
    if [ -s "$OUTPUT_DIR/$json_name" ]; then
        echo "⏭️  跳过: $filename"
        continue
    fi

    echo "🔍 正在审计: [$parent] -> $filename ..."

    # 重点：如果直接传路径失败，我们先尝试让它分析“文件名”
    # 真正的视频分析需要上传到 Google Cloud Storage 或通过 File API，
    # 这里我们先让它基于文件名和上下文生成索引，作为“初级审计”。
    gemini --yolo -m gemini-2.5-flash -p "你是一名显卡维修专家。请根据视频路径和名称：\"$video\"，推测其维修节点（如：阻值、供电、显存）并生成规范的 JSON 结构。即使你无法直接看到画面，也要基于文件名中的课程信息进行预测性标注。" > "$OUTPUT_DIR/$json_name"

    if [ $? -eq 0 ]; then
        echo "✅ 录入成功: $json_name"
    else
        rm -f "$OUTPUT_DIR/$json_name"
    fi
done
echo "🏁 递归审计完成。"
