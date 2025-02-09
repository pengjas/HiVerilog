import os

# 指定文件夹路径和输出文件路径
folder_path = r"D:\icrg\code\LLM_multi_modal\ICML_2025\GraphCoder\HiVerilog_eval_generated_code\fine_tune_havenllama_using_rtlcoder_gpt4_unfreeze_gnn_projector_with_lora\v0_best_ckpt_separate_lr_gnn8e3_projector3e4_lora3e5_batch2_epoch5\test_1"
output_file_path = r"D:\icrg\code\LLM_multi_modal\ICML_2025\HiVerilog\HiVerilog\test_on_benchmark\tasks_hiverilog.txt"

# 初始化一个集合来存储提取的前缀名
prefixes = set()

# 遍历文件夹中的所有文件
for filename in os.listdir(folder_path):
    if filename.endswith('.v'):
        # 提取前缀名，去掉文件扩展名
        prefix = filename[:-2]  # 去掉最后的 '.v'
        prefixes.add(prefix)

# 将提取的前缀名写入输出文件
with open(output_file_path, 'w') as output_file:
    for prefix in sorted(prefixes):  # 排序以保持一致性
        output_file.write(prefix + '\n')

print(f"提取的前缀名已写入 {output_file_path}")