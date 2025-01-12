import os
import json

def find_verified_files(base_path):
    data_list = []

    for root, dirs, files in os.walk(base_path):
        for file in files:
            if file.startswith("verified_") and file.endswith(".v"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r') as f:
                    code = f.read()
                
                folder_name = os.path.basename(root)
                task_id_dict = {
                    "task_id": folder_name,
                    "code": code
                }
                data_list.append(task_id_dict)

    return data_list

def append_to_jsonl(file_path, data_list):
    with open(file_path, 'a') as jsonl_file:
        for entry in data_list:
            jsonl_file.write(json.dumps(entry) + "\n")

if __name__ == "__main__":
    base_path = '.'  # 当前路径
    output_file = './reference_code.jsonl'

    data_list = find_verified_files(base_path)
    append_to_jsonl(output_file, data_list)

    print(f"数据已追加到 {output_file}")