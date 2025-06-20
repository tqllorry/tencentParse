#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import argparse
from datetime import date, timedelta
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


def process_file(input_file, output_file, info_fields_count1, max_kb):
    MAX_BYTES = int(max_kb * 1024)

    with open(output_file, 'wb') as final_out:
        with open(input_file, 'rb') as fin:  # 二进制模式读取
            for line_bytes in fin:
                try:
                    line = line_bytes.decode('utf-8')  # 显式解码
                except UnicodeDecodeError:
                    continue  # 或记录错误日志

                parts = line.rstrip('\n').split('\t')
                if len(parts) < info_fields_count1:
                    continue
                header, content = '\t'.join(parts[:(info_fields_count1 - 1)]), '\t'.join(
                    parts[(info_fields_count1 - 1):])

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
    parser = argparse.ArgumentParser(description='Split the overly long field')
    parser.add_argument('--ck_database', '-cd', help='必要参数', required=True)
    parser.add_argument('--ck_table', '-ct', help='必要参数', required=True)
    parser.add_argument('--info_fields_count', '-fc', help='必要参数', required=True)
    parser.add_argument('--manually_input_file', '-mif', help='可选参数', required=False)
    parser.add_argument('--manually_output_file', '-mof', help='可选参数', required=False)
    args = parser.parse_args()

    database = args.ck_database
    table = args.ck_table
    info_fields_count = args.info_fields_count
    manually_input_file = args.manually_input_file
    manually_output_file = args.manually_output_file

    # 如果没指定导入导出路径，默认为table名
    if not manually_input_file:
        manually_input_file = table

    if not manually_output_file:
        manually_output_file = table

    dt = (date.today() + timedelta(days=-1)).strftime("%Y%m%d")

    input_dir_path = "/data/tdbank/{}/{}".format(database, manually_input_file)
    output_dir_path = "/data/tdbank/{}/{}".format(database, manually_output_file)

    temp_tsv_path = "{}/temp_{}.tsv.all".format(input_dir_path, dt)
    tsv_path = "{}/{}.tsv.all".format(output_dir_path, dt)

    if not os.path.exists(output_dir_path):
        os.makedirs(output_dir_path)
        os.chmod(output_dir_path, 0777)
    else:
        if os.path.exists(tsv_path):
            os.remove(tsv_path)

    print("temp_tsv_path:", temp_tsv_path)
    print("tsv_path:", tsv_path)

    process_file(temp_tsv_path, tsv_path, int(info_fields_count), 450)

    # 删除临时文件
    if os.path.exists(temp_tsv_path):
        os.remove(temp_tsv_path)
