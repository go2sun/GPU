import os
import subprocess
import re
import sys

# M4 视觉审计系统 - 显存报错智能分析器 (ASCII 视觉版)

# 颜色代码 (ANSI)
RED_BLINK = '\033[5;31m'
RESET = '\033[0m'
GREEN = '\033[32m'

# GPU 字符画布局图 (通用 8 颗显存布局)
# E0 E1 E2
# E7 GPU E3
# E6 E5 E4
GPU_LAYOUT = [
    "   [E0]   [E1]   [E2]   ",
    "                        ",
    "   [E7]  [ GPU ] [E3]   ",
    "         [CORE ]        ",
    "                        ",
    "   [E6]   [E5]   [E4]   "
]

def draw_gpu_map(failing_channel):
    """绘制 GPU 布局图并高亮坏显存"""
    print("\n🗺️  [M4 视觉审计] GPU 显存物理映射图:")
    print("-" * 30)
    
    # 将通道名称 (如 B0, C1) 映射到 E0-E7 物理位置 (简化逻辑)
    # 通用映射参考：A->E0/E1, B->E2/E3, C->E4/E5, D->E6/E7
    mapping = {
        'A0': 'E0', 'A1': 'E1',
        'B0': 'E2', 'B1': 'E3',
        'C0': 'E4', 'C1': 'E5',
        'D0': 'E6', 'D1': 'E7'
    }
    
    target_failing_id = mapping.get(failing_channel, "NONE")

    for line in GPU_LAYOUT:
        if target_failing_id != "NONE" and target_failing_id in line:
            # 高亮闪烁坏显存
            colored_line = line.replace(f"[{target_failing_id}]", f"{RED_BLINK}[{target_failing_id}]{RESET}")
            # 其余标绿
            for eid in mapping.values():
                if eid != target_failing_id and f"[{eid}]" in colored_line:
                     colored_line = colored_line.replace(f"[{eid}]", f"{GREEN}[{eid}]{RESET}")
            print(colored_line)
        else:
            # 无故障行标绿核心和显存
            colored_line = line
            for eid in mapping.values():
                if f"[{eid}]" in colored_line:
                    colored_line = colored_line.replace(f"[{eid}]", f"{GREEN}[{eid}]{RESET}")
            if "[ GPU ]" in colored_line:
                colored_line = colored_line.replace("[ GPU ]", f"{GREEN}[ GPU ]{RESET}")
            if "[CORE ]" in colored_line:
                colored_line = colored_line.replace("[CORE ]", f"{GREEN}[CORE ]{RESET}")
            print(colored_line)
            
    print("-" * 30)
    print(f"提示: {RED_BLINK}红色闪烁{RESET} 表示故障位置 ({failing_channel} -> {target_failing_id})。")

def analyze_mats_logs():
    log_dir = "/Volumes/Ventoy/GPU/data/logs/"
    files = [os.path.join(log_dir, f) for f in os.listdir(log_dir) if 'mats' in f.lower() or 'report' in f.lower()]
    if not files:
        print("❌ [M4 系统] 未在 data/logs/ 中发现 MATS 日志文件。")
        return

    latest_log = max(files, key=os.path.getmtime)
    print(f"📂 正在审计最新日志: {os.path.basename(latest_log)}")

    with open(latest_log, 'r', encoding='utf-8', errors='ignore') as f:
        log_content = f.read()

    # 正则提取报错通道 (如 Channel B0)
    match = re.search(r"Memory errors detected on Channel (\w+)\.", log_content)
    failing_channel = match.group(1) if match else None

    # 调用 Gemini 进行深度分析
    prompt = f"你现在是 GPU 维修审计专家。以下是一份显存测试日志：\n---\n{log_content[:2000]}\n---\n请识别显卡型号、指出报错通道并给出维修建议。"
    print("🧠 [M4 系统] 正在通过 Gemini CLI 进行物理位置映射...")
    subprocess.run(["gemini", "-p", prompt])

    # 如果有报错通道，绘制视觉地图
    if failing_channel:
        draw_gpu_map(failing_channel)

if __name__ == "__main__":
    analyze_mats_logs()
