import os
import json
import re

def jsonline_iter(file_path: str):
    with open(file_path, "r") as f:
        for line in f:
            yield json.loads(line)

def example_to_jsonline(examples: dict, save_file: str):
    with open(save_file, "a") as f:
            f.write(json.dumps(examples) + "\n")


def find_module_string(text):
    # Regex pattern to find the string starting with "module" and ending with ";"
    # It uses non-greedy matching to find the shortest match
    pattern = r"module.*?;"
    
    # Using re.DOTALL to make the dot match all characters including newline
    match = re.search(pattern, text, re.DOTALL)
    
    if match:
        return match.group()  # Returns the matched string
    else:
        return None  # No match found
    
def prepend_verilog_module(verilog_code: str, current_folder: str, task_id: str) -> str:
    # 判断verilog_code是否以"module"开头
    if verilog_code.startswith("module"):
        return verilog_code

    # 遍历上一级文件夹的所有子文件夹
    parent_folder = os.path.abspath(os.path.join(current_folder, os.pardir))
    
    for root, dirs, files in os.walk(parent_folder):
        if task_id in dirs:
            task_id_folder = os.path.join(root, task_id)
            task_id_file = os.path.join(task_id_folder, f'verified_{task_id}.v')
            
            # 检查task_id.v文件是否存在
            if os.path.isfile(task_id_file):
                with open(task_id_file, 'r') as file:
                    task_id_content = file.read()
                module_head = find_module_string(task_id_content)
                if "verified_" in module_head:
                    # 去除 "verified_" 部分
                    module_head = module_head.replace("verified_", "")
                task_id_content = module_head + '\n'
                # 将内容填到verilog_code的开头
                return task_id_content + verilog_code

    return verilog_code  # 如果没有找到，返回原始代码

def parse_code(raw_code: str, task_id: str) -> str:
    # extract code from the answer:
    if "```verilog\n" in raw_code and "```" in raw_code:
        code = raw_code.split("```verilog\n")[1].split("```")[0]
    elif "```verilog\n" in raw_code and not "```" in raw_code:
        code = raw_code.split("```verilog\n")[1]
    elif "```" in raw_code and not "```verilog\n" in raw_code:
        code = raw_code.split("```")[1]
    elif not "```verilog\n" in raw_code:
        code = raw_code

    # s_full = code
    # s = s_full.rsplit('endmodule', 1)[0] + "\n" + "endmodule"
    # index = s.find('endmodule')
    # if index != -1:
    #     s = s[:index] + "endmodule"
    import re
    cleaned_code = re.sub(r'//.*', '', code)
    s = cleaned_code.lstrip(' \n')
    current_directory = os.getcwd()  # 当前目录
    s = prepend_verilog_module(verilog_code=s, current_folder=current_directory, task_id=task_id)
    s = s.rstrip(' \n')
    if not s.endswith("endmodule"):
        s += "\nendmodule"

    return s.lstrip(' \n')



def build_verilog_file(input_jsonl, output_dir):
    num_of_each_task = {}
    for item in jsonline_iter(input_jsonl):
        task_id = item["task_id"]
        code = item["response"]
        code = parse_code(code, task_id=task_id)
        if task_id not in num_of_each_task:
            num_of_each_task[task_id] = 1
        else:
            num_of_each_task[task_id] += 1
        os.makedirs(f"{output_dir}/test_{num_of_each_task[task_id]}", exist_ok=True)
        with open(f"{output_dir}/test_{num_of_each_task[task_id]}/{task_id}.v", "w") as f:
            f.write(code)

if __name__ == "__main__":
    build_verilog_file(r"D:\icrg\code\LLM_multi_modal\ICML_2025\GraphCoder\HiVerilog_eval_result\fine_tune_havenllama_using_rtlcoder_gpt4_unfreeze_gnn_projector_with_lora\v0_best_ckpt_separate_lr_gnn8e3_projector3e4_lora3e5_batch2_epoch5\eval_res.jsonl", r"D:\icrg\code\LLM_multi_modal\ICML_2025\GraphCoder\HiVerilog_eval_generated_code\fine_tune_havenllama_using_rtlcoder_gpt4_unfreeze_gnn_projector_with_lora\v0_best_ckpt_separate_lr_gnn8e3_projector3e4_lora3e5_batch2_epoch5")