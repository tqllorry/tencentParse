#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import argparse
from tempfile import NamedTemporaryFile

reload(sys)
sys.setdefaultencoding('utf-8')  # 全局编码设置


def split_content(content, max_bytes):
    # 类型安全处理
    if isinstance(content, bytes):
        byte_content = content
    else:
        byte_content = content.encode('utf-8')

    split_index = 0
    while len(byte_content) > 0:
        end = min(max_bytes, len(byte_content))
        chunk = byte_content[:end].decode('utf-8', errors='ignore')
        yield (split_index, chunk)
        byte_content = byte_content[end:]
        split_index += 1


def process_file(input_file, output_file, max_kb=400):
    MAX_BYTES = int(max_kb * 1024)

    with open(output_file, 'wb') as final_out:
        with open(input_file, 'rb') as fin:  # 二进制模式读取
            for line_bytes in fin:
                try:
                    line = line_bytes.decode('utf-8')  # 显式解码
                except UnicodeDecodeError:
                    continue  # 或记录错误日志

                parts = line.rstrip('\n').split('\t')
                if len(parts) != 4:
                    continue
                header, content = '\t'.join(parts[:3]), parts[3]

                if len(content.encode('utf-8')) <= MAX_BYTES:
                    final_out.write(line.encode('utf-8'))  # 统一编码写入
                    continue

                with NamedTemporaryFile(delete=False) as temp:
                    for idx, chunk in split_content(content, MAX_BYTES):
                        new_line = "%s_%d\t%s\n" % (header, idx, chunk)
                        temp.write(new_line.encode('utf-8'))
                    temp.seek(0)
                    final_out.write(temp.read())
                    os.unlink(temp.name)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_file', required=True)
    parser.add_argument('--output_file', required=True)
    args = parser.parse_args()
    process_file(args.input_file, args.output_file)
