import os
from datetime import datetime

# M4 视觉审计系统 - 视频教程审计组件
def generate_video_roadmap():
    # 设定扫描的根目录（GPU 资料存放处）
    base_path = "/Volumes/Ventoy/GPU"
    output_file = os.path.join(base_path, "docs/planning/GPU_Learning_Roadmap.md")
    
    # 支持的视频格式
    video_extensions = ('.mp4', '.avi', '.mov', '.mkv', '.flv')
    
    print(f"🔍 [M4 系统] 正在扫描视频教程并生成进度表...")

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"# 📹 GPU 维修视频教程学习进度表\n")
        f.write(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("| 课程名称 | 文件路径 | 学习状态 | 审计笔记 |\n")
        f.write("| :--- | :--- | :---: | :--- |\n")

        for root, dirs, files in os.walk(base_path):
            # 排除掉不需要扫描的系统目录
            if any(x in root for x in ['.git', 'scripts', '.m4_audit']):
                continue
                
            for file in sorted(files):
                if file.lower().endswith(video_extensions):
                    # 提取相对路径
                    relative_path = os.path.relpath(os.path.join(root, file), base_path)
                    # 写入 Markdown 表格行
                    f.write(f"| {file} | {relative_path} | ⬜ 未开始 | |\n")

    print(f"✨ [M4 系统] 学习全景图已生成至: {output_file}")

if __name__ == "__main__":
    generate_video_roadmap()