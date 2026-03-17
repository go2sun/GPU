#!/bin/bash
# M4 视觉审计系统 - 视频全自动处理插件 (整合落地版)

SOURCE_VIDEO="$1"
TEMP_SLIM="slim_${SOURCE_VIDEO%.*}.mp4"
# 自动定位至您的 Ventoy 挂载点
OUTPUT_JSON="/Volumes/Ventoy/GPU/repair_cases.json"

if [[ ! -f "$SOURCE_VIDEO" ]]; then
    echo "❌ 错误: 找不到视频文件 $SOURCE_VIDEO"
    exit 1
fi

echo "🛡️ [M4 视觉审计] 1/3: 启动 M4 极速压缩 (FFmpeg)..."
# 使用 Mac Mini M4 硬件加速建议（libx264）
/opt/homebrew/bin/ffmpeg -i "$SOURCE_VIDEO" -vf 'scale=720:-1' -c:v libx264 -crf 30 -an "$TEMP_SLIM" -y -loglevel quiet

echo "🚀 [M4 视觉审计] 2/3: 投喂 Gemini CLI 进行深度审计..."
# 注入专用“显存通道屏蔽”提示词逻辑
AUDIT_RESULT=$(gemini analyze "$TEMP_SLIM" --prompt "你是 M4 视觉审计系统。请分析此 GPU 维修视频，重点识别：1. MATS 报错通道；2. 显存屏蔽逻辑（BIOS或物理）；3. 关键点位阻值。请严格以结构化 JSON 格式输出，包含 case_id, model, steps, 和 conclusion 字段。不要输出任何解释性文字。")

echo "📊 [M4 视觉审计] 3/3: 写入数字化案例库..."
# 自动创建目录并追加结果
mkdir -p "$(dirname "$OUTPUT_JSON")"
echo "$AUDIT_RESULT" >> "$OUTPUT_JSON"

echo "✅ 审计完成！案例已归档至: $OUTPUT_JSON"
# 清理临时文件
rm "$TEMP_SLIM"