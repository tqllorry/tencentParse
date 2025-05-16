# -*- coding: utf-8 -*-
import argparse
import sys


def split_content(content, max_size=400 * 1024):
    content_bytes = content.encode('utf-8')
    if len(content_bytes) <= max_size:
        return [(0, content)]

    chunks = []
    index = 0
    start = 0
    while start < len(content_bytes):
        # 关键修复：强制转换为整数
        end = int(start + max_size)  # 确保索引为整数
        chunk = content_bytes[int(start):end].decode('utf-8', 'ignore')  # 双保险转换
        chunks.append((index, chunk))
        index += 1
        start = end  # 此处赋值需保持整数
    return chunks


def process_file(input_file, output_file):
    """处理文件主逻辑"""
    with open(input_file, 'r') as infile, open(output_file, 'wb') as outfile:
        for line_num, line in enumerate(infile):
            line = line.rstrip('\n')
            fields = line.split('\t')
            if len(fields) != 4:
                sys.stderr.write("跳过格式错误行:{}\n".format(line_num))
                continue

            srcdb, cdbid, id, content = fields
            chunks = split_content(content)

            for index, chunk in chunks:
                output_line = '\t'.join([
                    srcdb,
                    cdbid,
                    id,
                    str(index),
                    chunk.encode('utf-8')
                ]) + '\n'
                outfile.write(output_line)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_file', required=True)
    parser.add_argument('--output_file', required=True)
    args = parser.parse_args()

    process_file(args.input_file, args.output_file)


if __name__ == '__main__':
    main()
