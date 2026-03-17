import os
import sys
import time
import json
import google.generativeai as genai

# 配置区
API_KEY = "AIzaSyBuMIVR6Mcgq5zjwahe-IrZ0rfLg-tPD9I"
genai.configure(api_key=API_KEY)

def audit_video(video_path):
    print(f"🚀 正在上传并分析: {os.path.basename(video_path)}")
    
    # 1. 上传视频
    video_file = genai.upload_file(path=video_path)
    
    # 2. 等待视频处理完毕 (API 需要时间对视频进行索引)
    while video_file.state.name == "PROCESSING":
        time.sleep(2)
        video_file = genai.get_file(video_file.name)
        
    if video_file.state.name == "FAILED":
        raise Exception("视频处理失败")

    # 3. 调用模型 (使用稳定的 1.5-flash)
    model = genai.GenerativeModel('gemini-1.5-flash')
    prompt = """你是一名资深显卡维修专家。请分析视频内容，提取维修节点（如：阻值测量、核心植锡、显存屏蔽）及精确时间戳。
    要求：
    1. 严格使用中文。
    2. 只返回纯粹的 JSON 格式数据。
    3. 结构包含：video_name, audit_nodes: [{timestamp, event, detail}]。"""
    
    response = model.generate_content([video_file, prompt])
    
    # 4. 清理云端文件 (节省配额空间)
    genai.delete_file(video_file.name)
    
    return response.text

if __name__ == "__main__":
    target_dir = os.getcwd()
    output_dir = os.path.join(target_dir, "audit_results")
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    videos = [f for f in os.listdir(target_dir) if f.endswith('.mp4')]
    
    for v in videos:
        v_path = os.path.join(target_dir, v)
        json_path = os.path.join(output_dir, f"{os.path.splitext(v)[0]}.json")
        
        try:
            result = audit_video(v_path)
            # 过滤掉可能存在的 Markdown 标签 ```json
            clean_json = result.replace("```json", "").replace("```", "").strip()
            with open(json_path, 'w', encoding='utf-8') as f:
                f.write(clean_json)
            print(f"✅ 审计成功: {v}")
        except Exception as e:
            print(f"❌ 审计失败: {v} | 错误: {str(e)}")
