import json

# 指定 JSONL 文件路径
jsonl_file = 'hiverilog_graph.jsonl'  # 替换为你的文件路径

# 读取文件并输出每一行的 task_id
with open(jsonl_file, 'r', encoding='utf-8') as f:
    for line in f:
        try:
            entry = json.loads(line)  # 解析 JSON 行
            print(entry['task_id'])    # 输出 task_id
        except json.JSONDecodeError as e:
            print("解析错误:", e)
        except KeyError:
            print("该行没有 task_id 字段")