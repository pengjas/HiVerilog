import os
import shutil

# 定义路径
source_path = r"D:\icrg\code\LLM_multi_modal\ICML_2025\HiVerilog\HiVerilog"
destination_path = r"D:\icrg\code\LLM_multi_modal\ICML_2025\HiVerilog\HiVerilog\test_on_benchmark\testbench\HiVerilog"

# 遍历所有子文件夹
for root, dirs, files in os.walk(source_path):
    # 排除 test_on_benchmark 文件夹
    if 'test_on_benchmark' in root:
        continue

    # 检查是否存在 testbench.v 和 makefile
    if 'testbench.v' in files and 'makefile' in files:
        # 获取当前子文件夹的名称
        folder_name = os.path.basename(root)
        
        # 创建目标子文件夹路径
        target_folder = os.path.join(destination_path, folder_name)
        
        # 创建目标子文件夹
        os.makedirs(target_folder, exist_ok=True)
        
        # 复制 testbench.v 和 makefile 到目标子文件夹
        shutil.copy(os.path.join(root, 'testbench.v'), target_folder)
        shutil.copy(os.path.join(root, 'makefile'), target_folder)

print("文件夹复制完成。")