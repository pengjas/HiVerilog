import os
import json

# 定义函数将 jsonl 转换为字典
def jsonl_to_dict(jsonl_file):
    all_graph = {}
    with open(jsonl_file, 'r', encoding='utf-8') as f:
        for line in f:
            entry = json.loads(line)
            task_id = entry['task_id']
            graph = entry['graph']
            graph = graph.replace('\'', '\"')  # 将单引号替换为双引号
            graph = json.loads(graph)
            # 只取需要的键
            filtered_graph = {key: graph[key] for key in ['nodes', 'edge_attrs', 'connectivity'] if key in graph}
            all_graph[task_id] = filtered_graph
    return all_graph

# 定义函数遍历文件夹并写入 graph.json
def write_graph_json(all_graph, base_path):
    for root, dirs, files in os.walk(base_path):
        folder_name = os.path.basename(root)
        if folder_name in all_graph:
            graph_data = all_graph[folder_name]
            graph_json_path = os.path.join(root, 'graph.json')
            with open(graph_json_path, 'w', encoding='utf-8') as graph_file:
                json.dump(graph_data, graph_file, ensure_ascii=False, indent=4)

# 主程序
if __name__ == "__main__":
    jsonl_file = 'hiverilog_graph.jsonl'  # 将此替换为你的 jsonl 文件路径
    all_graph = jsonl_to_dict(jsonl_file)
    write_graph_json(all_graph, os.getcwd())  # 从当前工作目录开始遍历