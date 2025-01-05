## list all tasks folder's relative path
## Usage: python list_all_tasks.py
import os

def find_minimal_subdirectories(root_dir):
    minimal_dirs = []

    # 遍历目录树
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # 如果该文件夹没有子文件夹且不是根目录
        if not dirnames and dirpath != root_dir:
            # 将相对路径添加到列表中
            relative_path = os.path.relpath(dirpath, root_dir)
            minimal_dirs.append(relative_path)

    return minimal_dirs

# 设置当前路径
current_path = os.getcwd()
minimal_subdirs = find_minimal_subdirectories(current_path)
n = 0
# 打印最小子文件夹的相对路径
for subdir in minimal_subdirs:
    n += 1
    print(subdir)
print("Total number of subdirectories: ", n)