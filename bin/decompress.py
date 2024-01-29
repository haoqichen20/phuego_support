#! /usr/bin/env python

import gzip
import sys
import os

blocksize = 1 << 20  # 1MB

def gunzip_large_file(input_file, output_file):
    # Check if the input file exists
    if not os.path.isfile(input_file):
        print(f"Error: File '{input_file}' not found.")
        return

    with gzip.open(input_file, 'rb') as f_in:
        with open(output_file, 'wb') as f_out:
            while True:
                block = f_in.read(blocksize)
                if not block:
                    break
                f_out.write(block)

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py input.gz")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = input_file.rstrip('.gz')

    gunzip_large_file(input_file, output_file)

if __name__ == '__main__':
    main()
