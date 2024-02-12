#!/usr/bin/env python

import os,sys

def main():
	i_node = sys.argv[1]
	i_node_combi = sys.argv[2]
	xml_template_path = sys.argv[3]

	f1=open(xml_template_path)
	f2=open(str(i_node)+"_all.xml","w")
	seq=f1.readline()
	while(seq!=""):
		seq=seq.strip()
		if seq.startswith("output "):
			f2.write(f'output = "{str(i_node)}.txt"\n')
		elif seq.startswith("file"):
			# Paste the filename (instead of the full_path) of i_node_combi in the .xml
			# When feeding the .xml to the java program, symbolink the file to make it accessible.
			f2.write(f'file = "{i_node_combi}"\n')
		else:
			f2.write(seq+"\n")
		seq=f1.readline()

if __name__ == '__main__':
    main()