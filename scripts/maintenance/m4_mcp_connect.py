#!/usr/bin/env python3
import json
import argparse
import sys
from pathlib import Path

def update_claude_config(name, url, token):
    # macOS Claude Desktop 配置路径
    config_path = Path.home() / "Library/Application Support/Claude/claude_desktop_config.json"
    
    # 确保父目录存在
    config_path.parent.mkdir(parents=True, exist_ok=True)
    
    # 加载现有配置
    if config_path.exists():
        with open(config_path, 'r') as f:
            try:
                config = json.load(f)
            except json.JSONDecodeError:
                config = {"mcpServers": {}}
    else:
        config = {"mcpServers": {}}
    
    # 注入/更新服务配置
    if "mcpServers" not in config:
        config["mcpServers"] = {}
        
    config["mcpServers"][name] = {
        "type": "sse",
        "url": url,
        "env": {
            "MCP_TOKEN": token
        }
    }
    
    # 保存配置
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=2)
    
    print(f"[{name}] 已成功挂载到 M4 视觉审计系统。")
    print(f"配置路径: {config_path}")

def main():
    parser = argparse.ArgumentParser(description="M4 视觉审计系统 - MCP 远程大脑连接工具")
    parser.add_argument("url", help="远程 MCP 服务器地址")
    parser.add_argument("--token", required=True, help="鉴权 Token")
    parser.add_argument("--name", default="m4-remote-brain", help="大脑别名")
    
    args = parser.parse_args()
    
    update_claude_config(args.name, args.url, args.token)

if __name__ == "__main__":
    main()