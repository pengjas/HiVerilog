# import os
# import json

# def find_and_convert_jsonl_to_json(directory):
#     # 遍历当前文件夹及其所有子文件夹
#     for root, dirs, files in os.walk(directory):
#         # 检查当前文件夹中是否有 'graph.jsonl' 文件
#         if 'graph.jsonl' in files:
#             jsonl_path = os.path.join(root, 'graph.jsonl')
#             # 删除原来的 graph.jsonl 文件
#             os.remove(jsonl_path)

#     print("No 'graph.jsonl' file found in the directory or its subdirectories.")

# # 调用函数，从当前文件夹开始遍历
# find_and_convert_jsonl_to_json('.')
import os
import json

def process_graph_json(root_dir):
    # 遍历当前文件夹的所有子文件夹
    for subdir, _, files in os.walk(root_dir):
        # 检查是否存在graph.json文件
        if 'graph.json' in files:
            graph_json_path = os.path.join(subdir, 'graph.json')
            print(f"Processing {graph_json_path}")
            
            # 读取graph.json文件
            with open(graph_json_path, 'r') as file:
                graph_data = json.load(file)
            
            # 将内容改写为graph[0]
            if isinstance(graph_data, list) and len(graph_data) > 0:
                graph_data = graph_data[0]
            else:
                graph_data = [graph_data]
            
            # 将改写后的内容写回文件
            with open(graph_json_path, 'w') as file:
                json.dump(graph_data, file, indent=4)

# 调用函数，传入当前文件夹路径
current_directory = os.getcwd()
process_graph_json(current_directory)