import os
import subprocess
import sys

def sync_score_to_github(score, level, feedback):
    """通过 gh CLI 将审计结果推送到 GitHub Board"""
    title = f"维修能力评估: {level} (得分: {score})"
    body = f"审计日期: {os.popen('date').read()}\n考官评价: {feedback}"
    
    # 在 GitHub Board 上创建新卡片
    subprocess.run(["gh", "project", "item-create", "1", "--owner", "@me", "--title", title, "--body", body])
    print(f"📊 [M4 系统] 评分已同步至 GitHub Board。状态: {level}")

def start_interactive_quiz():
    # ... (保留之前的课程提取逻辑)
    
    # 模拟交互式评分过程
    print("🎓 考官正在阅卷...")
    # 这里我们让 Gemini 输出一个固定格式的评分，例如 "SCORE: 85"
    # 演示目的，我们假设一个交互结果
    user_answer = input("你的回答已提交，请输入 Gemini 给出的最终得分 (0-100): ")
    
    score = int(user_answer)
    if score >= 90:
        level = "Expert (专家)"
    elif score >= 70:
        level = "Technician (技师)"
    else:
        level = "Apprentice (学徒)"
        
    sync_score_to_github(score, level, "由 M4 视觉审计系统自动判定")

if __name__ == "__main__":
    start_interactive_quiz()