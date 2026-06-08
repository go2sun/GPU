import litellm
import os

def run_audit():
    # 1. 加载 Prompt
    with open("prompts/audit_main.prompt", "r", encoding="utf-8") as f:
        system_prompt = f.read()

    # 2. 读取待处理数据
    with open("data/raw_evidence.txt", "r", encoding="utf-8") as f:
        evidence_data = f.read()

    # 3. 调用本地模型 (通过 LiteLLM 路由)
    response = litellm.completion(
        model="m4-local", # 对应你在 config.yaml 定义的名称
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": f"证据数据如下：\n{evidence_data}"}
        ]
    )

    # 4. 输出结果
    result = response.choices[0].message.content
    with open("output/final_audit_report.md", "w", encoding="utf-8") as f:
        f.write(result)
    print("✅ 审计完成：报告已生成至 output/final_audit_report.md")

if __name__ == "__main__":
    run_audit()