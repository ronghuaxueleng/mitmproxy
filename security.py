# security.py  
import os
import subprocess

def block_shell():
    raise RuntimeError("Shell execution is blocked")

# 覆盖危险函数
os.system = block_shell
os.popen = block_shell
subprocess.Popen = block_shell
subprocess.call = block_shell